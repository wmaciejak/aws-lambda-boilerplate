def context_params
  instance_double \
    "ContextMock",
    clock_diff: 1617027203548,
    deadline_ms: 1617357673202,
    aws_request_id: :sample_id,
    invoked_function_arn: "arn:aws:lambda:eu-west-1:000000000000:function:lambda",
    log_group_name: "/aws/lambda/lambda",
    log_stream_name: "2021/04/02/[$LATEST]30340e8c612928ef85e6b28ca81672d4",
    function_name: "lambda",
    memory_limit_in_mb: 1536,
    function_version: "$LATEST",
    identity: {}
end
