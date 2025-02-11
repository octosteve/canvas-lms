#!/usr/bin/env bash

set -e

sudo update-rc.d redis-server enable
sudo service redis-server start
sudo service redis-server status

ruby -rerb -e 'puts ERB.new(File.read(".devcontainer/domain.yml.erb")).result(binding)' > config/domain.yml
cp config/database.yml.codespaces config/database.yml
cp config/security.yml.example config/security.yml
cp .devcontainer/cache_store.yml config/cache_store.yml
cp .devcontainer/redis.yml config/redis.yml
cp .devcontainer/dynamic_settings.yml config/dynamic_settings.yml
bundle install
yarn install

bundle exec rake db:initial_setup
bundle exec rails canvas:compile_assets_dev