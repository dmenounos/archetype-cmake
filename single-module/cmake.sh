#!/bin/bash

set -e

# cmake forward defines
DEF=""

# clean lifecycle phase
CLP=""

# build lifecycle phase
BLP=""

# module directory
MOD_DIR="."

# output directory
OUT_DIR="build"

# make verbose options
VERBOSE=""

while getopts ":D:cb:m:o:vh" OPT; do
	case $OPT in
	"D")
		DEF="$DEF -D$OPTARG"
		;;
	"c")
		CLP="clean"
		;;
	"b")
		case $OPTARG in
		"cmake"|"make"|"make-install")
			BLP="$OPTARG"
			;;
		*)
			echo "Valid arguments for -$OPT: cmake | make | make-install" 1>&2
			exit 1
			;;
		esac
		;;
	"m")
		if [ ! -d $OPTARG ]; then
			echo "Directory $OPTARG does not exist. Operation aborted." 1>&2
			exit 1
		fi

		MOD_DIR="$OPTARG"
		;;
	"o")
		OUT_DIR="$OPTARG"
		;;
	"v")
		VERBOSE="VERBOSE=1 --no-print-directory"
		;;
	"h")
		echo "Usage: $0 [OPTIONS]" 1>&2
		echo "OPTIONS" 1>&2
		echo "  -c clean lifecycle phase" 1>&2
		echo "  -b build lifecycle phase" 1>&2
		echo "  -m module directory" 1>&2
		echo "  -o output directory" 1>&2
		echo "  -v show compile commands" 1>&2
		echo "  -h this information" 1>&2
		echo "EXAMPLE" 1>&2
		echo "$0 -c" 1>&2
		echo "$0 -b make" 1>&2
		echo "$0 -c -b make" 1>&2
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

if [ "$#" -eq "0" ]; then
	$0 -h
	exit 1
fi

if [ -z "$CLP" ] && [ -z "$BLP" ]; then
	$0 -h
	exit 1
fi

cd $MOD_DIR

do_clean() {
	echo "## Clean - Removing output directory"
	rm -rf $OUT_DIR
}

do_cmake() {
	echo "## Build - Creating output directory"
	mkdir -p $OUT_DIR

	cd $OUT_DIR
	echo "## Build - Executing cmake"
	cmake $DEF ..
	cd ..
}

do_make() {
	if [ ! -d "$OUT_DIR" ]; then
		do_cmake
	fi

	cd $OUT_DIR
	echo "## Build - Executing make"
	make $VERBOSE
	cd ..
}

do_make_install() {
	if [ ! -d "$OUT_DIR" ]; then
		do_make
	fi

	cd $OUT_DIR
	echo "## Build - Executing make install"
	make install
	cd ..
}

if [ "$CLP" == "clean" ]; then
	do_clean
fi

if [ "$BLP" == "cmake" ]; then
	do_cmake
fi

if [ "$BLP" == "make" ]; then
	do_make
fi

if [ "$BLP" == "make-install" ]; then
	do_make_install
fi
