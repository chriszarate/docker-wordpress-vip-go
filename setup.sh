#!/usr/bin/env bash

if [ ! -f docker-compose.yml ]; then
  echo "Please run this script from the root of the docker-vip repo."
  exit 1
fi

if [ ! -z "$(docker-compose ps | sed -e '/^\-\-\-/,$!d' -e '/^\-\-\-/d')" ]; then
  echo "Please run \`docker-compose down\` before running this script. (You will need"
  echo "to reimport content after this script completes.)"
  exit 1
fi

# Make sure environment is up to date.
./update.sh

# Make sure self-signed TLS certificates exist.
./certs/create-certs.sh

# Done!
echo ""
echo "Done! You are ready to run \`docker-compose up -d\`."
