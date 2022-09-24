These scripts is useful for creating a layer on the AWS Lambda, thus decreasing its weight.

Open CLI and run:

1. rm -r myArtifacts* layer/ node_modules/*
2. npm ci --production
3. ./prepareModules.sh
4. npm ci
5. npm run create-package:dev
6. npm run deploy-package:dev

there is also an *serverless.yml* example file that implements the layer in each the Lambdas of the microservice
