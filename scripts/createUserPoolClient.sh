RESULT=$(aws cognito-idp create-user-pool --pool-name haier-$MIGRATION_ENV-third-part)
USER_POOL_ID=($(jq -r '.UserPool.Id' <<< $RESULT))
echo $USER_POOL_ID
RES=$(aws cognito-idp create-user-pool-client --user-pool-id $USER_POOL_ID --client-name MY-CUSTOMER)
