#args: 1--> queue name
aws sqs create-queue --queue-name $1 --attributes { "VisibilityTimeout": "30", "MaximumMessageSize": "262144", "MessageRetentionPeriod": "345600", "DelaySeconds": "0", "ReceiveMessageWaitTimeSeconds": "0", "SqsManagedSseEnabled": "false” }
