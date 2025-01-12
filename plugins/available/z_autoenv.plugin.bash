# shellcheck shell=bash
# shellcheck disable=SC2207
cite about-plugin
about-plugin 'source into environment when cding to directories'

if [[ -n "${ZSH_VERSION}" ]]; then
	__array_offset=0
else
	__array_offset=1
fi

function autoenv_init {
	typeset home _file
	typeset -a _files
	home="${HOME%/*}"

	_files=($(
		while [[ "$PWD" != "/" && "$PWD" != "$home" ]]; do
			_file="$PWD/.env"
			if [[ -e "${_file}" ]]; then
				echo "${_file}"
			fi
			builtin cd .. || return
		done
	))

	_file=${#_files[@]}
	while ((_file > 0)); do
		# shellcheck disable=SC1090
		source "${_files[_file - __array_offset]}"
		: $((_file -= 1))
	done
}

cd() {
	if builtin cd "$@"; then
		autoenv_init
		return 0
	else
		echo "else?"
		return $?
	fi
}
