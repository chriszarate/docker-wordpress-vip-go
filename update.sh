#!/usr/bin/env bash

echo "Updating environment...."
git fetch && git pull origin master && echo ""

# Make sure src directory exists.
mkdir -p src

# Clone git repos.
for repo in \
  Automattic/vip-go-mu-plugins \
  Automattic/vip-go-skeleton \
  tollmanz/wordpress-pecl-memcached-object-cache
do
  # Clone repo if it is not in the "src" subfolder.
  if [ ! -d "src/${repo##*/}/.git" ]; then
    echo "Cloning $repo in the \"src\" subfolder...."
    rm -rf src/${repo##*/}
    git clone --recursive git@github.com:$repo src/${repo##*/}
  fi

  # Make sure repos are up-to-date.
  echo "Updating ${repo##*/}...."
  pushd src/${repo##*/} >/dev/null && \
    git pull origin master --ff-only && \
    git submodule update && \
    popd >/dev/null && \
    echo ""
done
