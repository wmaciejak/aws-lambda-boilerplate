#!/bin/sh

docker run --rm -v $PWD/$1:/var/layer -w /var/layer amazon/aws-sam-cli-build-image-ruby2.7 bash -c $'
rm -rf gems \
&& bundle config set --local path \'gems\' \
&& bundle install \
&& mv gems/ruby/* gems/ \
&& rm -rf gems/2.7.0/cache \
&& rm -rf gems/ruby \
&& rm -rf .bundle
'
