# S3-batch-delete
Shell scripts for deleting millions of s3 objects

## The Problem
How to delete 100 million+ files from an s3 bucket while not touching some of the files and not
having any downtime?

## Possible Solutions

A. Delete the bucket and create a new one
  * we were not allowed downtime so this do not work

B. Delete files via the web ui
  * not possible considering the web ui does not even properly calculate the number of pagination
    pages it would need to view all the files.

C. Modify the life cycle rules on the bucket to delete files matching a prefix after one day
  * our files did not have consistent names and we were absolutely not allowed to accidentally delete
    say a file with matching prefix in a sub folder that is not to be touched.

D. Use the aws cli `s3 rm `...
  * this solution does have the `--include` and `--exclude` optional parameters which should make it
    possible but we have to exclude just to many things to make this practical

**F. Use the aws cli `s3api --delete`**
  * this allows for deleting up to 1000 files by name at a time and in the end was what we looked to
    script for use of deleting 100 million+ files

## How to use

1. get a list of files you need to delete via the aws cli, `aws s3 ls s3://bucket-example`
  * sometimes this can take a while and will need to run on a server overnight
1. clone the repo somewhere and build the scripts, see [Dev](#dev)
1. check you list of objects file and make sure there is nothing in there you don't want to delete
  * text editors like [ed](https://en.wikipedia.org/wiki/Ed_(text_editor)) come in handy for this
    sort of editing because million+ line files kill a lot of text editors
1. split up this cleaned up file with `./create_files.sh --split 80000 --output ./del_files_dir s3_ls.txt`
  * the split number should be approx the number items you are seeking delete divided by 10 so that
    10 processes are started and not more so you don't reach api rate limit
1. now that we have files delete the objects with `./del_files --bucket bucket-example ./del_files_dir`
  * this will start up the processes in the background but there will output to the current terminal
    so often its a good idea to do such things on a server after running `screen` to start up a
    detachable terminal that can run overnight. Tip: `Ctrl-D` is default for detaching.


## Dev
This project started as a few sparse scripts on a ec2 node. This repo seeks to
collect and standardize them into a tool usable by others.

In order to build you need a few thing.  
**Requirements:**  
[argbash](https://github.com/matejak/argbash/releases)

Edit scripts and run `make clean && make` in the project root
