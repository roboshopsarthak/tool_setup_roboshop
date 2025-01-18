resource "aws_iam_role" "role" {
  name = "${var.tool_name}_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
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

resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.tool_name}_role"
  role = aws_iam_role.role.name
}