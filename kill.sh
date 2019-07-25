#!/bin/bash

ps aux | grep 'del_files.sh$' | awk '{print $2}' | xargs kill -9

