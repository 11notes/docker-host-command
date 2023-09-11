#!/bin/ash
  if [ -z "$1" ]; then
    set -- "node" /api/start.js ${CONFIG}
  fi

  exec "$@"