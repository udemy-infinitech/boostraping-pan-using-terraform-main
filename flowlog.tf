resource "aws_flow_log" "flow_log_vpc" {
  iam_role_arn    = aws_iam_role.FlowLogIAMRole.arn
  log_destination = aws_cloudwatch_log_group.flow_log.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.vpc.id
  max_aggregation_interval = 60
}

resource "aws_cloudwatch_log_group" "flow_log" {
  name = "AWSFlowlog"
}

resource "aws_iam_role" "FlowLogIAMRole" {
  name = "example"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "vpc-flow-logs.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}


resource "aws_iam_role_policy" "flow_log_Profile" {
  name = "flow_log_profile"
  role = aws_iam_role.FlowLogIAMRole.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents",
        "logs:DescribeLogGroups",
        "logs:DescribeLogStreams"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_cloudwatch_log_stream" "FlowLogsStream" {
  name           = "LogStreamForFlowLogs"
  log_group_name = aws_cloudwatch_log_group.flow_log.name
}