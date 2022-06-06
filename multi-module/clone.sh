#!/bin/bash

set -e

# project id
PROJECT_ID=""

# output directory
OUT_DIR=".."

while getopts ":p:o:h" OPT; do
	case $OPT in
	"p")
		PROJECT_ID="$OPTARG"
		;;
	"o")
		OUT_DIR="$OPTARG"
		;;
	"h")
		echo "Usage $0 [OPTIONS]" 1>&2
		echo "OPTIONS" 1>&2
		echo "  -p Project id" 1>&2
		echo "  -o Output directory" 1>&2
		echo "EXAMPLE" 1>&2
		echo "$0 -p myproject -o ../.." 1>&2
		exit 1
		;;
	":")
		echo "Option -$OPTARG requires an argument" 1>&2
		exit 1
		;;
	"?")
		echo "Invalid option: -$OPTARG" 1>&2
		exit 1
		;;
	esac
done

if [ -z "$PROJECT_ID" ]; then
	$0 -h
	exit 1
fi

OUT_DIR=${OUT_DIR%/}
OUT_DIR="$(cd "$OUT_DIR" && pwd)"

# Confirm the creation of new project

echo -n "Create $OUT_DIR/$PROJECT_ID (y/n) "
read CONFIRM_CREATE

if [ $CONFIRM_CREATE != "y" ]; then
	exit 1
fi

# Confirm the deletion of existing project

if [ -d "$OUT_DIR/$PROJECT_ID" ]; then
	echo -n "Delete existing $OUT_DIR/$PROJECT_ID (y/n) "
	read CONFIRM_DELETE

	if [ $CONFIRM_DELETE != "y" ]; then
		exit 1
	fi

	rm -rf "$OUT_DIR/$PROJECT_ID"
fi

# Clone archetype to project

mkdir -p "$OUT_DIR/$PROJECT_ID"

cp -r "cmake"           "$OUT_DIR/$PROJECT_ID"
cp -r "prototype-bin"   "$OUT_DIR/$PROJECT_ID/$PROJECT_ID-bin"
cp -r "prototype-lib"   "$OUT_DIR/$PROJECT_ID/$PROJECT_ID-lib"
cp ".gitignore"         "$OUT_DIR/$PROJECT_ID"
cp "CMakeLists.txt"     "$OUT_DIR/$PROJECT_ID"
cp "cmake.sh"           "$OUT_DIR/$PROJECT_ID"

sed -i "s/prototype/$PROJECT_ID/g" "$OUT_DIR/$PROJECT_ID/CMakeLists.txt"
sed -i "s/prototype/$PROJECT_ID/g" "$OUT_DIR/$PROJECT_ID/$PROJECT_ID-bin/CMakeLists.txt"
sed -i "s/prototype/$PROJECT_ID/g" "$OUT_DIR/$PROJECT_ID/$PROJECT_ID-lib/CMakeLists.txt"
