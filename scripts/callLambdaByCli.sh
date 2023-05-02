touch payload.json


cat > payload.json <<EOF
{
// MY PAYLOAD HERE
}
EOF
aws lambda invoke \
--function-name MY_LAMBDA_NAME \
--cli-binary-format raw-in-base64-out \
--payload file://./payload.json out \
--log-type Tail \
--query 'LogResult' \
--output text |  base64 -d 
