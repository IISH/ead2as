#!/bin/bash


# remove double spaces
SOURCE=out
TARGET=temp1
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed 's/  \+/ /g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# remove space(s) before ending tags, example space </tag>
SOURCE=temp1
TARGET=temp2
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed 's/ \+<\//<\//g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# remove space(s) between > and character, example > space A
SOURCE=temp2
TARGET=temp3
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/(>) {1,}([a-zA-Z0-9])/\1\2/g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# add dummy data to protect removing empty lb
SOURCE=temp3
cd $SOURCE || exit
for FILE in *.xml; do
   sed -i 's/<lb\/>/<lb>_DUMMY_DATA_<\/lb>/g' "$FILE"
   sed -i 's/<lb><\/lb>/<lb>_DUMMY_DATA_<\/lb>/g' "$FILE"
done
cd ..


# remove empty tags (1) example <tag:sub />
SOURCE=temp3
TARGET=temp4
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/<[a-zA-Z]+:?[a-zA-Z]* *\/>//g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# remove empty tags (2)
SOURCE=temp4
TARGET=temp5
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/<([a-zA-Z]+:?[a-zA-Z]*) *><\/\1 *>//g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# remove dummy data from lb
SOURCE=temp5
cd $SOURCE || exit
for FILE in *.xml; do
   sed -i 's/<lb>_DUMMY_DATA_<\/lb>/<lb\/>/g' "$FILE"
done
cd ..


# verwijder overbodige namespace
SOURCE=temp5
TARGET=temp6
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/<([a-zA-Z]+:?[a-zA-Z]*) *><\/\1 *>//g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# verwijder achtergebleven namespace prefix en declaratie
SOURCE=temp6
TARGET=out2
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/ xmlns:ead="urn:isbn:1-931666-22-9"|ead://g' "$FILE" > "../$TARGET/$FILE"
done
cd ..

rm -rf temp?/

# print one xml file
#EXAMPLE=ARCH04724
#tail $TARGET/$EXAMPLE.xml
