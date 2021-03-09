# frozen_string_literal: true

require "json"

def lambda_handler(event:, context:)
  {
    statusCode: 200,
    body: JSON.generate("OK"),
  }
end
