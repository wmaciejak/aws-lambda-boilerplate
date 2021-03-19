#!/bin/sh

image=amazon/aws-sam-cli-build-image-ruby2.7
module=$1

if [ -z "$module" ]; then
  echo "Usage: $0 <module>"
  exit 1
fi

docker run --rm -v $PWD/$module:/var/layer -w /var/layer $image sh -c "
  set -x \
  && rm -rf gems \
  && bundle config set --local path 'gems' \
  && bundle install \
  && mv gems/ruby/* gems/ \
  && rm -rf gems/2.7.0/cache \
  && rm -rf gems/ruby \
  && rm -rf .bundle \
  && chown -R $(id -u):$(id -g) gems/
"
