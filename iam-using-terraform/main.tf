############################
# 1) Create IAM User
############################
resource "aws_iam_user" "dev_user" {
  name = "dev-user"
}


############################
# 2) Create IAM Group
############################
resource "aws_iam_group" "dev_group" {
  name = "dev-group"
}


############################
# 3) Attach User to Group
############################
resource "aws_iam_user_group_membership" "attach_user_group" {
  user   = aws_iam_user.dev_user.name
  groups = [aws_iam_group.dev_group.name]
}


############################
# 4) Attach AWS Managed Policy to Group
############################
resource "aws_iam_group_policy_attachment" "group_policy" {
  group      = aws_iam_group.dev_group.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}


############################
# 5) Create a Custom IAM Policy
############################
resource "aws_iam_policy" "custom_ec2_policy" {
  name        = "Custom-EC2-Policy"
  description = "Allow starting and stopping EC2 Instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = [
        "ec2:StartInstances",
        "ec2:StopInstances",
        "ec2:DescribeInstances"
      ]
      Resource = "*"
    }]
  })
}


############################
# 6) Create IAM Role
############################
resource "aws_iam_role" "ec2_role" {
  name = "EC2-Access-Role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}


############################
# 7) Attach Custom Policy to Role
############################
resource "aws_iam_role_policy_attachment" "attach_custom_policy" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.custom_ec2_policy.arn
}
############################
# 8) EC2 Instance with IAM Role
# Launch an EC2 instance.
# Attach the EC2-Access-Role to it.
# The EC2 instance will run a script that automatically stops another EC2 instance every night.
############################
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "EC2-Access-Instance-Profile"
  role = aws_iam_role.ec2_role.name
}
resource "aws_instance" "example" {
  ami           = "ami-07860a2d7eb515d9a" # Example AMI ID, replace with a valid one for your region
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  user_data = <<-EOF
              #!/bin/bash
              yum install -y aws-cli

              # Example: Stop a target EC2 instance at boot
              TARGET_INSTANCE_ID="i-0586fd61096410745"
              aws ec2 stop-instances --instance-ids $TARGET_INSTANCE_ID --region us-east-1
              EOF

  tags = {
    Name = "ec2-controller"
  }
}

