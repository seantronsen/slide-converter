#!/bin/bash

set -ex

if (($# == 0)); then
	echo "no args"
	echo "slide-converter <pdf-filename> <note-name>"
	exit 1
fi

INFILENAME=$1
OUTFILENAME=$2
TARG_DIR="note-$OUTFILENAME"
UNIQUE_NAME="$OUTFILENAME-$(date "+%Y%m%d%H%M%S")"
INTERMEDIATE=intermediate.pdf

if [[ ! -f "$INFILENAME" ]]; then
	echo "file not found: $INFILENAME"
	exit 1
fi

if [[ -f "$OUTFILENAME" ]]; then
	echo "file exists, will not overwrite: $OUTFILENAME"
	exit 1
fi

mkdir "$TARG_DIR" && cd "$TARG_DIR"
pdftoppm -jpeg "../${INFILENAME}" "$OUTFILENAME"
convert $OUTFILENAME*.jpg $INTERMEDIATE
pdftohtml -p $INTERMEDIATE "${UNIQUE_NAME}.html"
pandoc -s "${UNIQUE_NAME}s.html" -o "${OUTFILENAME}.md"
mkdir -p attachments
mv *.jpg attachments/
rm *.html INTERMEDIATE.pdf

BAKEXT='.bak'
# remove extra separators
sed -I $BAKEXT 's/^-\{3,\}$//' $OUTFILENAME.md

# remove slide numbering
sed -I $BAKEXT 's/^\[\]{.*}//' $OUTFILENAME.md

# remove trailing backslash
sed -I $BAKEXT 's/\\$//' $OUTFILENAME.md

# convert pathnames
sed -I $BAKEXT 's/!\[\](/!\[\](attachments\//' $OUTFILENAME.md
rm *.bak
