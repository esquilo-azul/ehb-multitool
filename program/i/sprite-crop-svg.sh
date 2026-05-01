#!/bin/sh

source "${BASH_TO_REQUIRE}"

if [ $# -lt 4 ]; then
    echo "Usage: $0 <SVG_SOURCE> <COLUMNS> <ROWS> <RESIZE>"
    exit 1
fi

SVG_SOURCE=$1
COLUMNS=$2
ROWS=$3
RESIZE=$4

SOURCE_DIR=`dirname "$SVG_SOURCE"`
CROP=$COLUMNS'x'$ROWS'@'
TMPDIR=`mktemp -d`
FORMAT="$TMPDIR/%02d.png"

echo "Source: $SVG_SOURCE"
echo "Source Dir: $SOURCE_DIR"
echo "Rows: $ROWS"
echo "Columns: $COLUMNS"
echo "Crop: $CROP"
echo "Tmpdir: $TMPDIR"
echo "Format: $FORMAT"
echo "Resize: $RESIZE"
convert "$SVG_SOURCE" -crop "$CROP" +repage +adjoin "$FORMAT"

FILES="$TMPDIR/*"
for FILE in $FILES; do
    TARGET="$SOURCE_DIR/"`basename "$SVG_SOURCE"`'-'`basename "$FILE"`
    echo '----------------------------------'
    echo $FILE
    echo $TARGET
    convert "$FILE" -transparent white -resize "$RESIZE" "$TARGET"
done


rm -rf "$TMPDIR"
