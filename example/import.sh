#!/bin/bash

# Zet deze NS in de /etc/hosts als

FINAL="$1" && [ ! -d "$FINAL" ] && echo "./import.sh [pad naar folder met ead documenten] [file van rapportage] ontbreekt" && exit 1
RAPPORT="$2" && [ ! -f "$FINAL" ] && echo "./import.sh [pad naar folder met ead documenten] [file van rapportage] ontbreekt" && exit 1
ADMIN_USERNAME="$3" && [ -z "$ADMIN_USERNAME" ] && echo "Naam rol admin gebruiker nodig."
ADMIN_PASSWORD="$4" && [ -z "$ADMIN_PASSWORD" ] && echo "Password nodig."

URL="http://as-backend-acc.collections.iisg.org"
JSON="${FINAL}/jsonmodel_from_format"
LOG="${FINAL}/log"

mkdir "$JSON" "$LOG"

# De sessie
echo "export TOKEN=$(curl -Fpassword=${ADMIN_PASSWORD} http://$URL/users/${ADMIN_USERNAME}/login | jq '.session')" >.session
source .session
([ -n "$TOKEN" ] && echo "$TOKEN") || (echo "Geen token?" && exit 1) # De curl oproep zet de sessie id.

while read -r line; do
  IFS=',' read -r name a b c d e f g h i j k l m n o p q r repository <<<"$line"

  case "$repository" in
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

  ead_file="${FINAL}/${name}.xml"
  CMD="/usr/bin/curl -H 'Content-Type: text/xml' -H 'X-ArchivesSpace-Session: ${TOKEN}' -X POST -d @${ead_file} 'http://${URL}/plugins/jsonmodel_from_format/resource/ead'"
  echo "$CMD"
  #(eval "$CMD" >"json" && echo "OK format ${ead_file}" >> "$LOG") || echo "BAD format ${ead_file}" >> "$LOG"

  asmodel_file="${JSON}/${name}.json" && [ -f "$asmodel_file" ] && rm "$asmodel_file"
  log_file="${JSON}/${name}.log" && [ -f "$log_file" ] && rm "$log_file"
  CMD="/usr/bin/curl -H 'Content-Type: application/json' -H 'X-ArchivesSpace-Session: ${TOKEN}' -X POST -d @${asmodel_file} 'http://URL/repositories/${repo}/batch_imports'"
  echo "$CMD"
  #(eval "$CMD" >"$log_file" && echo "OK import ${asmodel_file}" >> "$LOG") || echo "BAD import ${asmodel_file}">> "$LOG"
done <"$RAPPORT"