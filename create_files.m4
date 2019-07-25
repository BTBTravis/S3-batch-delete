#!/bin/bash

# m4_ignore(
echo "This is just a script template, not the script (yet) - pass it to 'argbash' to fix this." >&2
exit 11  #)Created by argbash-init v2.8.1
# ARG_OPTIONAL_SINGLE([split],[s],[number of objects to delete per process], [10000])
# ARG_OPTIONAL_SINGLE([output],[o],[folder to create files])
# ARG_OPTIONAL_BOOLEAN([clean], [c], [delete files in output folder?], [off])
# ARG_POSITIONAL_SINGLE([file], [file containing s3 object games to delete, raw output of aws s3 ls])
# ARG_HELP([<The general help message of my script>])
# ARGBASH_GO

# [ <-- needed because of Argbash

TMP_FOLDER=/tmp/s3-clean-"$(date +%s)"
mkdir -p "$TMP_FOLDER"

# clean output folder if needed
[[ "$_arg_clean" == "on" ]] && rm -r "$_arg_output"/*


echo "=== transforming s3 ls --> names ==="
NAMES_FILE=/tmp/s3-clean-names-"$(date +%s)"
cat "$_arg_file" | awk '{print $4}' > "$NAMES_FILE"

# TODO: check for folders? as we don't support deleting them i think
#echo "=== checking for folders ==="
#[[ -n `grep 'PRE ' "$NAMES_FILE"` ]] && echo "fround folder" && exit 1

# Split into hour_files
(
    cd "$TMP_FOLDER"
    split -l "$_arg_split" "$NAMES_FILE"
)

SPLIT_FILES=`ls "$TMP_FOLDER`

echo "=== creating 950 files ==="

while read -r hour_file; do
    mkdir "$_arg_output""$hour_file"
    (cd "$_arg_output""$hour_file" && split -l 950 "$TMP_FOLDER"/"$hour_file")
done <<< "$SPLIT_FILES"

echo "=== finished creating folders and files ==="
tree "$_arg_output" | tail -1

rm -r "$TMP_FOLDER"

# ] <-- needed because of Argbash

dnl vim: filetype=sh
