#!/bin/bash

export MIX_ENV=prod
export PORT=5001
export NODEBIN='pwd'/assets/node_modules/.bin
export PATH="$PATH:$NODEBIN"

echo "Beginning deploy of Eventapp..."

mix deps.get
mix compile
(cd assets && npm install)
(cd assets && npm run deploy)
mix phx.digest
mix release

echo "Deploy successful, starting Eventapp..."

PROD=t ./start.sh
