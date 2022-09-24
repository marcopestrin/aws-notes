#!/usr/bin/env bash
set -e

# prepare AWS node-module-layer
mkdir -p layer/nodejs
cp -RL node_modules layer/nodejs

# list of modules to exclude
rm -rf layer/nodejs/node_modules/aws-sdk \
  layer/nodejs/node_modules/@serverless \
  layer/nodejs/node_modules/chai \
  layer/nodejs/node_modules/prettier \
  layer/nodejs/node_modules/rxjs \
  layer/nodejs/node_modules/@babel \
  layer/nodejs/node_modules/@hapi