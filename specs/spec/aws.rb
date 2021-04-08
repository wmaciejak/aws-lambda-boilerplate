
require "aws-sdk"

Aws.config.update(region: "eu-west-1", credentials: Aws::Credentials.new("123", "qwe"))
