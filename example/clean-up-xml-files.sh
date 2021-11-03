#!/bin/bash


# remove double spaces
SOURCE=out
TARGET=temp1
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed 's/  \+/ /g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


SOURCE=temp1
cd $SOURCE || exit
for FILE in *.xml; do
   # remove space(s) before ending tags, example [space]</tag>
   sed -i 's/ \+<\//<\//g' "$FILE"

   # remove space(s) after ending </tag> if not alphanum character
   sed -i -E 's/(<\/[a-zA-Z0-9]{1,}>) {1,}([^a-zA-Z0-9])/\1\2/g' "$FILE"

   # remove space(s) after starting <tag>, example <did>[space]
   sed -i -E 's/(<[a-zA-Z0-9]{1,}>) {1,}/\1/g' "$FILE"

   # add dummy data to protect removing empty lb
   sed -i 's/<lb\/>/<lb>_DUMMY_DATA_<\/lb>/g' "$FILE"
   sed -i 's/<lb><\/lb>/<lb>_DUMMY_DATA_<\/lb>/g' "$FILE"
done
cd ..


# remove empty tags (1) example <tag:sub />
SOURCE=temp1
TARGET=temp4
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's/<[a-zA-Z]+:?[a-zA-Z]* *\/>//g' "$FILE" > "../$TARGET/$FILE"
done
cd ..


# remove empty tags (2)
SOURCE=temp4
for i in {1..4}; do
   TARGET=temp5.${i}
   mkdir -p $TARGET ; cd $SOURCE || exit
   for FILE in *.xml; do
      sed -E 's/<([a-zA-Z]+:?[a-zA-Z]*) *><\/\1 *>//g' "$FILE" > "../$TARGET/$FILE"
   done
   cd ..
   SOURCE=temp5.${i}
done


# remove dummy data from lb
SOURCE=temp5.${i}
cd $SOURCE || exit
for FILE in *.xml; do
   sed -i 's/<lb>_DUMMY_DATA_<\/lb>/<lb\/>/g' "$FILE"
done
cd ..


# verwijder overbodige namespace
SOURCE=temp5.${i}
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
rm -rf temp?.?/


# print one xml file
#EXAMPLE=ARCH04724
#tail $TARGET/$EXAMPLE.xml
