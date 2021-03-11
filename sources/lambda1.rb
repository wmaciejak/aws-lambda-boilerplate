# frozen_string_literal: true

require "json"

def lambda_handler(event:, context:)
  puts "\n\n\n\n"
  puts event.to_json
  puts "\n\n\n\n"
  puts context.to_json
  puts "\n\n\n\n"
  {
    statusCode: 200,
    body: JSON.generate("Lambda 1 say 'OK'"),
  }
end
