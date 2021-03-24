# frozen_string_literal: true

def lambda_handler(event:, context:)
  {
    statusCode: 200,
    body: JSON.generate(event),
  }
end
