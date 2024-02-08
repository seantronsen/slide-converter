#!/bin/bash
################################################################################
################################################################################
# Author: Sean Tronsen
#
# Simple bash utility to convert PDF slides and documents to markdown format.
# Such allows for adding additional notes to these materials using your
# favorite editor as opposed to be limited to Adobe Acrobat, PowerPoint, etc.
#
# NOTE: The transition from PDF to markdown is lossy in the sense that the text
# content is not preserved. Instead, the result created is intended to serve as
# a template where the original content (pages/slides) are displayed as images.
# Although this isn't necessarily ideal, it was the simplest idea to implement
# for the time being so that I could get back to work.
#
# Functional Interface
# - $1: 		name/path to the source PDF file
# - $2 			name of the target note (no extension)
#
# Successful execution of the script will result in the creation of a
# subdirectory named similarly to the specified output base filename in
# addition to a myriad of shell output. Contained within that directory is the
# converted note file in the form of a markdown document and another
# subdirectory titled 'attachments' which contains the original documents
# content in the form of JPEGs.
#
################################################################################
################################################################################

set -e
source "$(dirname $(realpath ${BASH_SOURCE[0]}))/lib.bash"

if (($# != 2)); then
	echo "$(basename $0) <path-to-pdf> <out-basename>"
	error "improper number of arguments specified"
fi

################################################################################
# Provided an input string:
# - strip out all non-alphanumeric characters
# - convert all multiple spaces to single space, then convert the remaining
#		spaces to hyphens
# - convert string to lowercase
#
# Return the resulting string to the caller.
#
# Arguments:
# 	$1: input string
# Returns:
# 	return via echo the output string which conforms to the function
# 	description
################################################################################
function str-formatter() {
	echo $1 | tr [:upper:] [:lower:] |
		sed 's/\( \)\{2,\}/ /g' |
		sed 's/ /-/g' |
		sed 's/[^a-z0-9-]//g' |
		sed 's/-\+$//' |
		sed 's/^-\+//'

}
FILE_IN=$1
FILE_OUT=$(str-formatter $2)
DIR_BUILD="converted-$FILE_OUT"
EPOCH="$(date "+%s")"
FILE_OUT_UNIQUE="$FILE_OUT-$EPOCH"
INTERMEDIATE="intermediate-$EPOCH.pdf"
OBJS="*.html $INTERMEDIATE"

if [[ ! -f "$FILE_IN" ]]; then
	error "file not found: $FILE_IN"
elif [[ -f "$FILE_OUT" ]]; then
	error "file exists, will not overwrite: $FILE_OUT"
fi

mkdir "$DIR_BUILD" && cd "$DIR_BUILD"
pdftoppm -jpeg "../${FILE_IN}" "$FILE_OUT"
convert $FILE_OUT*.jpg $INTERMEDIATE
pdftohtml -p $INTERMEDIATE "${FILE_OUT_UNIQUE}.html"
pandoc -s "${FILE_OUT_UNIQUE}s.html" -o "${FILE_OUT}.md"
mkdir -p attachments
mv *.jpg attachments/
rm "$OBJS"

##################################################
##################################################
# ITEMS TO AUTOMATICALLY REMOVE
#
# - remove extra separators
# - remove slide numbering
# - remove trailing backslash
# - convert pathnames
##################################################
##################################################
BAKEXT='.bak' # sed backup extension
sed -I $BAKEXT 's/^-\{3,\}$//' $FILE_OUT.md
sed -I $BAKEXT 's/^\[\]{.*}//' $FILE_OUT.md
sed -I $BAKEXT 's/\\$//' $FILE_OUT.md
sed -I $BAKEXT 's/!\[\](/!\[\](attachments\//' $FILE_OUT.md
rm *.bak
