#!/bin/bash

FINAL="$1" && [ ! -d "$FINAL" ] && echo "./import.sh [pad naar folder met ead documenten] [file van rapportage] ontbreekt" && exit 1
RAPPORT="$2" && [ ! -f "$RAPPORT" ] && echo "./import.sh [pad naar folder met ead documenten] [file van rapportage] ontbreekt" && exit 1
ADMIN_USERNAME="$3" && [ -z "$ADMIN_USERNAME" ] && echo "Naam rol admin gebruiker nodig." && exit 1
ADMIN_PASSWORD="$4" && [ -z "$ADMIN_PASSWORD" ] && echo "Password nodig." && exit 1
OPNIEUW="$5"

URL="http://as-backend-acc.collections.iisg.org"
JSON="${FINAL}/jsonmodel_from_format" && mkdir "$JSON"
LOG="${FINAL}/log.txt" && [ -f "$LOG" ] && rm "$LOG"


# De sessie
function login() {
	echo "export TOKEN=$(curl -Fpassword=${ADMIN_PASSWORD} $URL/users/${ADMIN_USERNAME}/login | jq '.session')" >.session
	source .session && rm ".session"
}

login

([ -n "$TOKEN" ] && echo "$TOKEN") || (echo "Geen token?" && exit 1) # De curl oproep zet de sessie id.

while read -r line; do
  IFS=',' read -r name a b c d e f g h i j k l m n o p q r repository <<<"$line"

  # We geven de variablele 'repo' het nummer van de archivesspace repository identifier.
  case "$repository" in
  'IISG')
    repo="2"
    ;;
  'IISH')
    repo="2"
    ;;
  'HBM')
    repo="3"
    ;;
  'NEHA')
    repo="4"
    ;;
  'SVZ')
    repo="5"
    ;;
  'NIBG')
    repo="6"
    ;;
  'IHLIA')
    repo="7"
    ;;
  esac

  # Eerst vragen we archivesspace de XML om te zetten in het AS json datamodel
  ead_file="${FINAL}/${name}.xml" && [ ! -f "$ead_file" ] && echo "File not found ${ead_file}" >> "$LOG" && continue
  asmodel_file="${JSON}/${name}.json"
  [ -f "$asmodel_file" ] && [ -z "$OPNIEUW" ] && echo "Skip ${asmodel_file}" && continue
  CMD="/usr/bin/curl -H 'Content-Type: text/xml' -H 'X-ArchivesSpace-Session: ${TOKEN}' -X POST -d @${ead_file} -o ${asmodel_file} '${URL}/plugins/jsonmodel_from_format/resource/ead'"
  echo "$CMD"
  (eval "$CMD" && echo "OK format ${ead_file}" >> "$LOG") || echo "BAD format ${ead_file}" >> "$LOG"

  # Hebben we nog een sessie?
  grep -q "SESSION_GONE" "$asmodel_file" && login && continue


  # Nu importeren we het json model in AS in de repository.
  log_file="${JSON}/${name}.log" && [ -f "$log_file" ] && rm "$log_file"
  CMD="/usr/bin/curl -H 'Content-Type: application/json' -H 'X-ArchivesSpace-Session: ${TOKEN}' -X POST -d @${asmodel_file} -o ${log_file} '${URL}/repositories/${repo}/batch_imports'"
  echo "$CMD"
  eval "$CMD" && echo "OK import ${asmodel_file}" >> "$LOG" || echo "BAD import ${asmodel_file}">> "$LOG"
done <"$RAPPORT"