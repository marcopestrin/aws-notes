tar -czvf myArtifacts.tar.gz ./myArtifacts && export AWS_PROFILE=dev && ./node_modules/.bin/sls deploy --verbose --stage dev --package myArtifacts
