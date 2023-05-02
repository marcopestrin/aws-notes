#!/bin/bash

# Set your AWS region and provider ID
ENV=
AWS_REGION=
SECRET_MANGAER=
NEW_PROVIDER=
API_NAME=

PROVIDER_ID=$(aws apigateway get-rest-apis --region $AWS_REGION | jq -r '.items[] | select(.name == "'"$API_NAME"'") | .id')

if [ -z "$PROVIDER_ID" ]; then
  echo "Could not find API Gateway with name $API_NAME in region $AWS_REGION"
  exit 1
fi

# Generate a new API key with a unique name
API_KEY_NAME="apiKey${NEW_PROVIDER}-${ENV}"
API_KEY_RESPONSE=$(aws apigateway create-api-key --name $API_KEY_NAME --enabled --generate-distinct-id --region $AWS_REGION)

# Extract the API key ID and value from the response
API_KEY_ID=$(echo $API_KEY_RESPONSE | jq -r '.id')
API_KEY_VALUE=$(echo $API_KEY_RESPONSE | jq -r '.value')

# Add the new API key to the provider with a dynamic authorizer URI
AUTHORIZER_URI="arn:aws:apigateway:$AWS_REGION:secretsmanager:path/${SECRET_MANGAER}"
AUTHORIZER_URI=${AUTHORIZER_URI/${SECRET_MANGAER}/$(echo $API_KEY_VALUE | base64)}

aws apigateway create-authorizer \
  --rest-api-id $PROVIDER_ID \
  --name $API_KEY_NAME \
  --type API_KEY \
  --identity-source 'method.request.header.Authorization' \
  --provider-arns "arn:aws:apigateway:$AWS_REGION:kms:alias/aws/secretsmanager" \
  --authorizer-uri $AUTHORIZER_URI \
  --authorizer-result-ttl-in-seconds 0 \
  --api-key $API_KEY_VALUE \
  --region $AWS_REGION

echo "New API key generated and added to provider $PROVIDER_ID for API Gateway $API_NAME"
echo "API key ID: $API_KEY_ID"
echo "API key value: $API_KEY_VALUE"
