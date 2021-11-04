#!/bin/bash

echo "Verdeel de EAD over repositories"

for doc in *.xml
do
  grep '<repository encodinganalog="852$a" label="Repository"><corpname> International Institute of Social History </corpname>

        <repository encodinganalog="852$a" label="Repository"><corpname>Internationaal Instituut voor Sociale Geschiedenis|</corpname>'
done