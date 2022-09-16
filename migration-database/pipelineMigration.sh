#!/bin/bash
Env='dev'
echo "Doing migration for $Env"

# we get the secretId and region based on env inside migrationSecretArns.json and migrationSecretRegion.json
secretId=($(jq -r --arg environment "$Env" '. | to_entries[] | select(.key==$environment) | .value' ./migrationSecretArns.json))
region=($(jq -r --arg environment "$Env" '. | to_entries[] | select(.key==$environment) | .value' ./migrationSecretRegion.json))

# we get the reletive secret
secretStr=$(aws secretsmanager get-secret-value --profile $Env --region $region --secret-id  $secretId --query 'SecretString' --output text 2>&1)

# we export all variables expect the identity file
for s in $(echo  $secretStr | jq -r 'to_entries[] | select(.key!="bastionIdentityKey") | "export \(.key)=\(.value)"'); do
  export $s
done

export privateKey=$(echo $secretStr | jq -r '.bastionIdentityKey' | sed -e 's/\\n/\n/g') 
node createTunnelAndMigrate.js
