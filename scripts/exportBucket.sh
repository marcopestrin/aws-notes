#args: 1--> source 2--> destination
aws s3 cp --recursive s3:$1 $2
#without final slash
