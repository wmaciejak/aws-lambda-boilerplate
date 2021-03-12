# frozen_string_literal: true

require "json"
require "faraday"
require "aws-sdk-dynamodb"

def lambda_handler(event:, context:)
  puts "\n\n#{dynamodb_client.config}\n\n"
  puts dynamodb_client.list_tables

  puts "\n\n\n\n"
  puts event.to_json
  puts "\n\n\n\n"
  puts context.to_json
  puts "\n\n\n\n"

  response = Faraday.get 'https://google.com/'
  puts response.status

  {
    statusCode: 200,
    body: JSON.generate("Lambda 1 say 'OK'"),
  }
end

def dynamodb_client
  if ENV["LOCALSTACK_HOSTNAME"]
    Aws::DynamoDB::Client.new endpoint: "http://#{ENV["LOCALSTACK_HOSTNAME"]}:4566"
  else
    Aws::DynamoDB::Client.new
  end
end
