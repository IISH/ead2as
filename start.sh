#!/bin/bash

echo "Begin met conversie"
CMD="java -jar target/ead2as-1.0.jar example/FINAL example/out" && echo "$CMD" && eval "$CMD"

echo "Opschonen"
cd example
./clean-up-xml-files.sh
