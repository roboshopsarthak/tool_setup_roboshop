resource "aws_iam_role" "role" {
    count = length(var.policy_list)
    name = "${var.tool_name}_role"
    assume_role_policy = <<EOF
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
    }
    EOF
    tags = {
        name = "${var.tool_name}_role"
    }
}

resource "aws_iam_policy" "policy" {
  count = length(var.policy_list)
  name        = "${var.tool_name}_inline_role"
  description = "Policy for ${var.tool_name} role"

  policy = <<EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": ${jsonencode(var.policy_list)},
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
  tags = {
        name = "${var.tool_name}_role_copilot"
    }
}

resource "aws_iam_role_policy_attachment" "role_policy_attachment" {
  count = length(var.policy_list)
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}

resource "aws_iam_instance_profile" "instance_profile" {
  count = length(var.policy_list)
  name = "${var.tool_name}_role"
  role = aws_iam_role.role.name
}