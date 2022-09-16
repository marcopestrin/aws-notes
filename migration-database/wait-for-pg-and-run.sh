#!/bin/sh

set -e

until PGPASSWORD=$password psql -h "$host" -U $user -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done
  
>&2 echo "Postgres is up - executing command"
node main.js