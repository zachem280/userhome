#!/bin/bash

usage() {
    echo "User: userhome [-f file] [username]"
    echo "Options:"
    echo "  -f file     Specify password file"
    echo "  --help      Show help"
    echo "  --usage     Show usage"	
}

file="/etc/passwd"
username=""

while [[ $# -gt 0 ]]; do
    case "$1" in
        -f)
            if [[ $# -lt 2 ]]; then
                usage >&2
                exit 1
            fi
            file="$2"
            shift 2
            ;;

        --help|--usage)
            usage
            exit 0
            ;;

        -*)
            usage >&2
            exit 1
            ;;

        *)
            if [[ -n "$username" ]]; then
                usage >&2
                exit 1
            fi
            username="$1"
            shift
            ;;

    esac
done

if [[ ! -f "$file" ]]; then
    echo "Error: file '$file' not found" >&2
    exit 2
fi

if [[ -z "$username" ]]; then
    username=$(id -un)
fi

entry=$(grep "^${username}:" "$file")

if [[ -z "$entry" ]]; then
    echo "Error: user '$username' not found" >&2
    exit 1
fi

home=$(echo "$entry" | cut -d: -f6)
echo "$home"
exit 0
