resource "aws_iam_instance_profile" "bootstrap_s3_profile" {
  name = "bootstrap_s3_profile"
  role = aws_iam_role.bootstrap_s3_role.name
}

resource "aws_iam_role" "bootstrap_s3_role" {
  name = "bootstrap_s3_role"
  path = "/"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource aws_iam_role_policy "bootstrap_s3_role_policy" {
  name = "test_policy"
  role = aws_iam_role.bootstrap_s3_role.id

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "ListObjectsInBucket",
            "Effect": "Allow",
            "Action": ["s3:ListBucket"],
            "Resource": ["arn:aws:s3:::*"]
        },
        {
            "Sid": "AllObjectActions",
            "Effect": "Allow",
            "Action": "s3:*Object",
            "Resource": ["arn:aws:s3:::*"]
        }
    ]
}
EOF
}
