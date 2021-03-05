#!/bin/bash

export MIX_ENV=prod
export PORT=5050

echo "Beginning deploy of Eventapp..."

mix deps.get --only prod
mix compile

mix ecto.migrate

(cd assets && npm install --prefix)
(cd assets && npm run deploy --prefix)
mix phx.digest
mix release

echo "Deploy successful..."
echo "Run start.sh to start your app"
