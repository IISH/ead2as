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


# verwijder achtergebleven namespace prefix
SOURCE=temp5
TARGET=out2
mkdir -p $TARGET ; cd $SOURCE || exit
for FILE in *.xml; do
   sed -E 's~(</?)ead:~\1~g' "$FILE" > "../$TARGET/$FILE"
done
cd ..

rm -rf temp?/

# print one xml file
#EXAMPLE=ARCH04724
#tail $TARGET/$EXAMPLE.xml
