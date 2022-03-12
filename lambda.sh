#!/usr/bin/bash
# args: 1-->functionName 2-->payload 3-->profile
aws lambda invoke --function-name $1 --payload $2 --cli-binary-format raw-in-base64-out --profile $3 /dev/stdout

