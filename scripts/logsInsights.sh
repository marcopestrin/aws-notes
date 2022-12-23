#!/bin/bash
ENVIRONMENT=$1
LAMBDA="microservice-${ENVIRONMENT}-myLambda"
START_TIME=$2
END_TIME=$3
STRING_TO_FIND_IN_MESSAGE_1=$4
STRING_TO_FIND_IN_MESSAGE_2=$5

# convert start time in unix timestamp
START_TIME=$(date -j -f '%d-%b-%Y %T' "${START_TIME}" +%s)
echo "The unix start time Timestamp: $START_TIME"
echo " "
END_TIME=$(date -j -f '%d-%b-%Y %T' "${END_TIME}" +%s)
echo "The unix start end Timestamp: $END_TIME"
echo " "

# prepare the query string
QUERY_STRING="
fields @timestamp, @message \
| filter @message like '${STRING_TO_FIND_IN_MESSAGE_1}' and @message like '${STRING_TO_FIND_IN_MESSAGE_2}' \
| sort @timestamp desc \
| limit 200"
echo "The query string is: $QUERY_STRING"
echo " "

# run the query and retrieve the query id
QUERY_ID=$(aws logs start-query \
--log-group-name /aws/lambda/$LAMBDA \
--start-time $START_TIME \
--end-time $END_TIME \
--query-string "$QUERY_STRING" | jq -r .queryId)

echo "QUERY_ID: ${QUERY_ID}"

# wait for the query completion
QUERY_STATUS=""
while [ "$QUERY_STATUS" == "" ] || [ "$QUERY_STATUS" == "Running" ] || [ "$QUERY_STATUS" == "Scheduled" ]
do
  QUERY_STATUS=$(aws logs get-query-results --query-id "${QUERY_ID}" --output=json | jq -Rsc '. / "\n" - [""]')
done
echo "The query status is: ${QUERY_STATUS}"
echo " "

# get and print results
RESULTS=$(aws logs get-query-results --query-id "${QUERY_ID}" --output=json | jq -Rsc '. / "\n" - [""]')
echo $RESULTS | sed 's@\\@@g' >> results.json
echo "DONE! "


# run:
# ./logsInsights.sh dev '12-Dec-2022 10:30:00' '21-Dec-2022 17:30:00' 