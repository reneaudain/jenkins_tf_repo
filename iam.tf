
resource "aws_iam_role" "s3_role_for_ec2" {
  name = "jenkins_role"


  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
#The instance Profile that we are attaching the role to
resource "aws_iam_instance_profile" "s3_role_for_ec2" {
  name = "s3_profile"
  role = aws_iam_role.s3_role_for_ec2.name
}
#the policies that we are attaching to the role
resource "aws_iam_role_policy_attachment" "policy_attachment" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess",
    "arn:aws:iam::503271535804:policy/EC2_S3_TEST"
  ])
  role = aws_iam_role.s3_role_for_ec2.name
  policy_arn = each.value
}


