resource "aws_iam_role" "role" {
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
    inline_policy {
    name = "${var.tool_name}_inline_role"

    policy = <<EOF
        Version = "2012-10-17"
        Statement = [
        {
            Action   = var.policy_list
            Effect   = "Allow"
            Resource = "*"
        EOF
    }
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tool_name}_role"
  role = aws_iam_role.role.name
}