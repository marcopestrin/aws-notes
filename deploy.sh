#!/usr/bin/bash
# args: 1 environment 
./node_modules/.bin/ sls deploy --verbose --stage $1
