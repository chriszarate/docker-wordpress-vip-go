#!/usr/bin/env bash

echo "Updating environment...."
git fetch && git pull origin master && echo ""

# Make sure src directory exists.
mkdir -p src

# Edit this value to your VIP Go repo.
wp_repo="Automattic/vip-go-skeleton"

# Clone git repos.
for repo in \
  $wp_repo \
  Automattic/vip-go-mu-plugins \
  tollmanz/wordpress-pecl-memcached-object-cache
do
  dir_name="${repo##*/}"
  if [ "$repo" == "$wp_repo" ]; then
    dir_name="wp"
  fi

  # Clone repo if it is not in the "src" subfolder.
  if [ ! -d "src/$dir_name/.git" ]; then
    echo "Cloning $repo in the \"src\" subfolder...."
    rm -rf src/$dir_name
    git clone --recursive git@github.com:$repo "src/$dir_name"
  fi

  # Make sure repos are up-to-date.
  echo "Updating $repo...."
  pushd src/$dir_name >/dev/null && \
    git pull origin master --ff-only && \
    git submodule update && \
    popd >/dev/null && \
    echo ""
done
