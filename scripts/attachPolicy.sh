#!/bin/bash
BASEDIR=$(dirname "$0")
echo "$BASEDIR"
source "$BASEDIR/../.migration"
echo $AWS_PROFILE
echo $AWS_DEFAULT_REGION

role_name="my-microservice-lambda"
policy_name="my-microservice-${MIGRATION_ENV}"

echo "creating role ${role_name}"
aws iam create-role --role-name $role_name --assume-role-policy-document "file://$BASEDIR/files/assumedRole.json"

# Creating temporary file env
cat files/policyTemplate.json | sed "s/_ENVIRONMENT_REGION_/$AWS_DEFAULT_REGION/g" | sed "s/_ENVIRONMENT_ACCOUNT_ID_/$ID_ACCOUNT/g" > policy-$MIGRATION_ENV.json

echo "creating policy ${policy_name}"
policy_arn=$(aws iam create-policy --policy-name $policy_name --policy-document "file://$BASEDIR/policy-$MIGRATION_ENV.json" | jq -r '.Policy.Arn')

echo "attaching create policy ${policy_arn}"
aws iam attach-role-policy --policy-arn $policy_arn --role-name $role_name
