#!/bin/bash
echo $AWS_PROFILE
echo $AWS_DEFAULT_REGION

role_name="my-microservice-role-${MIGRATION_ENV}"
echo "Role name: ${role_name}"
aws iam update-assume-role-policy --role-name $role_name --policy-document "file://$BASEDIR/files/assumedRole.json"

policy_name="my-microservice-policy-${MIGRATION_ENV}"
echo "Creating policy ${policy_name}"
policy_arn=$(aws iam create-policy --policy-name $policy_name --policy-document "file://$BASEDIR/files/policy.json" | jq -r '.Policy.Arn')
echo "Attaching create policy ${policy_arn}"

aws iam attach-role-policy --policy-arn $policy_arn --role-name $role_namek