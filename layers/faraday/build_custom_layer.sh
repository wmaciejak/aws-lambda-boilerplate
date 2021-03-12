docker run --rm -v $PWD:/var/layer \
           -w /var/layer \
           amazon/aws-sam-cli-build-image-ruby2.7 \
           bundle install --path=gems

mv gems/ruby/* gems/ \
  && rm -rf gems/2.7.0/cache \
  && rm -rf gems/ruby

zip -r layer.zip gems

rm -rf .bundle

