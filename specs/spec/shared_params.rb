def event_params
  {
    "path": "/lambda",
    "headers": headers,
    "multiValueHeaders": transform_to_multi_values(headers),
    "pathParameters": {},
    "body": "",
    "isBase64Encoded": false,
    "resource": "/restapis/9ewwthcl3u/dev/_user_request_/lambda",
    "httpMethod": http_method,
    "queryStringParameters":  query_params,
    "multiValueQueryStringParameters": transform_to_multi_values(query_params),
    "requestContext": {
        "path": "/dev/lambda",
        "accountId": "000000000000",
        "resourceId": "4sb5srwudu",
        "stage": "dev",
        "identity": {
          "accountId": "000000000000",
          "sourceIp": "127.0.0.1",
          "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36"
        },
        "httpMethod": http_method,
        "protocol": "HTTP/1.1",
        "requestTime": "2021-04-02T08:52:54.576Z",
        "requestTimeEpoch": 1617353574576
    },
    "stageVariables": {}
  }
end

def transform_to_multi_values(hash)
  hash.transform_values { |x| [x] }
end

def query_params
  {}
end

def http_method
  "GET"
end

def headers
  {
    "Remote-Addr": "192.168.0.1",
    "Host": "localhost:4566",
    "Connection": "keep-alive",
    "Cache-Control": "max-age=0",
    "Sec-Ch-Ua": "\"Google Chrome\";v=\"89\", \"Chromium\";v=\"89\", \";Not A Brand\";v=\"99\"",
    "Sec-Ch-Ua-Mobile": "?0",
    "Dnt": "1",
    "Upgrade-Insecure-Requests": "1",
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 11_2_3) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/89.0.4389.90 Safari/537.36",
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.9",
    "Sec-Fetch-Site": "none",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-User": "?1",
    "Sec-Fetch-Dest": "document",
    "Accept-Encoding": "gzip, deflate, br",
    "Accept-Language": "pl-PL,pl;q=0.9,en-US;q=0.8,en;q=0.7",
    "Cookie": "_legacy_auth0.is.authenticated=true; auth0.is.authenticated=true",
    "X-Forwarded-For": "192.168.0.1, localhost:4566, 127.0.0.1, localhost:4566",
    "x-localstack-edge": "https://localhost:4566",
    "Authorization": "test"
  }
end
