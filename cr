#!/bin/zsh

# help menu
usage="\033[1mUsage\033[0m:
	$(basename $0) [option] {file}
\033[1mCompile & Run\033[0m:
	c = compile ONLY
	r = dry run
	t = run and test
\033[1mDependency\033[0m:
	bat, gcc, exa, zsh
\033[1mLanguage\033[0m:
	C++"

language="cpp"

#function dependency_check {
#	declare -a dependency=(bat gcc exa zsh dick)
#	for d in "${dependency[@]}"; do
#		#where $d || true && exit 2
#		true || false && echo "dick"
#	done
#}
# if no option then exit after printing usage
[[ $# -lt 1 ]] && echo -e "$usage" >&2 && exit 1

# get the file name
function generate_filename {
	if [[ -n $2 ]]; then
		file=$"$2"
	else
		file=$(exa --sort=time *.c* | tail -n 1)
	fi
	# seperate filename and extension
	extension="${file##*.}"
	filename="${file%.*}"
}

# c -> function to compile and create an executable file
function gcc_compile {
	generate_filename
	g++ -o "$filename" "$file"
}

# i -> init file
function init {
	boiler_plate="$DATA/boiler_plate/c_plus_plus.cc"
	name=$(date +%Y%m%d%H%M%S)
	cp $boiler_plate "$name.cc"
	echo -e "$name.cc created :)"
}

# r -> function to dry run
function dry_run {
	generate_filename
	./"$filename"
}

# t -> function to run the binary against the in*.txt files and time them also
function test_run {
	generate_filename
	for f in in*.txt; do
		echo -e "$f\n========"
		time ./"$filename" < $f
		echo
	done
}

case $1 in
	h|-h|--help) echo -e "$usage" && exit ;;
	c) gcc_compile ;;
	i) init ;;
	r) dry_run ;;
	t) test_run ;;
	*) echo -e "$usage" >&2 && exit 2 ;;
esac

