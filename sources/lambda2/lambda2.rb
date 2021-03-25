# frozen_string_literal: true

require "json"

def lambda_handler(event:, context:)
  response_body = {
    # Hash of request headers, e.g. { "Content-Type"=>"application/json", "User-Agent"=>"PostmanRuntime/7.26.2" }
    headers: event.fetch("headers"),

    # String with request body, e.g. "{\"param1\": 1}"
    body: event.fetch("body"),

    # Hash of query string params, e.g. for "a=1&b[]=2&b[]=3&c[d]=4&e=5&e=6"
    # it returns {"a"=>"1", "b[]"=>["2", "3"], "c[d]"=>"4", "e"=>["5", "6"]}
    querystring_params: event.fetch("queryStringParameters"),

    # Hash of ENV variables
    env: ENV.to_h,
  }

  {
    statusCode: 200,
    body: JSON.generate(response_body),
  }
end
