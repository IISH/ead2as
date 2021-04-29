#!/bin/bash


echo '<?xml version="1.0" encoding="UTF-8"?>'
echo '<marc:catalog xmlns:marc="http://www.loc.gov/MARC21/slim" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.loc.gov/MARC21/slim http://www.loc.gov/standards/marcxml/schema/MARC21slim.xsd">'

for file in out/*.xml
do
	cat $file
	echo "" 
done

echo '</marc:catalog>'
