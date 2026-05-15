#!/bin/sh

for DIRECTORY in $*; do
  for PDF_FILE in `find "$DIRECTORY" -name '*.pdf'`; do
    NAME="${PDF_FILE%.*}"
    echo "Extraindo imagens de $PDF_FILE"
    mkdir -p "$DIRECTORY/$NAME"
    pdfimages -j "$DIRECTORY/$PDF_FILE" "$DIRECTORY/$NAME/pg"
  done
done
