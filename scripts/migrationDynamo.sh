#!/bin/bash
#dynamo
aws dynamodb put-item --table-name ${TABLE_NAME}-${MIGRATION_ENV} --item '{"PK": {"S": ""}, "SK": {"S": ""}, "createdAt": {"S": ""}}' --profile ${PROFILE}-${MIGRATION_ENV} --region ${DYNAMODB_REGION}
