#!/bin/sh
# local text dictionary
# download dictionary here:
# 	https://github.com/sujithps/Dictionary/raw/master/Oxford%20English%20Dictionary.txt

cat dox/dic | sed '/^$/d' | fzf -q "^"
