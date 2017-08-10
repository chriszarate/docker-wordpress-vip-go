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
echo "Updating environment...."
git fetch && git pull

# Make sure src directory exists.
mkdir -p src

# Clone git repos.
for repo in \
  Automattic/vip-go-mu-plugins \
  Automattic/vip-go-skeleton
do
  # Clone repo if it is not in the "src" subfolder.
  if [ ! -d "src/${repo##*/}/.git" ]; then
    echo "Cloning $repo in the \"src\" subfolder...."
    rm -rf src/${repo##*/}
    git clone --recursive git@github.com:$repo src/${repo##*/}
  fi
done

# Make sure vip-go-mu-plugins is up-to-date.
git --git-dir=src/vip-go-mu-plugins/.git --work-tree=src/vip-go-mu-plugins pull --ff-only

# Make sure self-signed TLS certificates exist.
./certs/create-certs.sh

# Done!
echo ""
echo "Done! You are ready to run \`docker-compose up -d\`."
