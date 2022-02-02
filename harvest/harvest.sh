#!/bin/bash

for metadata_prefix in oai_ead oai_marc
do
  while read -r resource_id repo_id
  do
    identifier="oai:archivesspace.iisg.amsterdam://repositories/${repo_id}/resources/${resource_id}"
    url="https://as-oai-acc.collections.iisg.org/?verb=GetRecord&identifier=${identifier}&metadataPrefix=${metadata_prefix}"
    CMD="curl -X GET -o '${metadata_prefix}/${repo_id}_${resource_id}.xml' '$url'"
    echo "$CMD" && eval "$CMD"
  done < "id.txt"
done