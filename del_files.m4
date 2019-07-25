#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.8.1
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO

# [ <-- needed because of Argbash

function process_file()
{
    JSON="{ \"Objects\":[ "
    while read -r line; do
        JSON="${JSON} {\"Key\":\"${line}\"},"
    done <<< "$1"
    JSON=`echo "$JSON" | sed 's/,*$//g'`
    JSON="$JSON""]}"
    aws s3api delete-objects --bucket "$_arg_bucket" --delete """$JSON""" > /dev/null
    JSON=""
}

for folder in "$_arg_folder"/* ; do
    (
        for file in "$folder"/* ; do
            printf "Processing file: ${file}\n"
            process_file "`cat "$file"`"
        done
    ) &
done


# ] <-- needed because of Argbash
dnl vim: filetype=sh
