#!/bin/bash

export MIX_ENV=prod
export PORT=5050

_build/prod/rel/eventapp/bin/eventapp start
