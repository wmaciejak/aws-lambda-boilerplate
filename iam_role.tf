resource "aws_iam_role" "iam_role" {
  name = "iam_role"
  max_session_duration=3600
  description        = "None"
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "sqs:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
