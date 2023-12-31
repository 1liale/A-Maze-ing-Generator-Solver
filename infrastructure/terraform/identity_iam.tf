resource "aws_iam_policy" "jenkins_policy" {
  name        = "jenkins-policy"
  description = "Jenkins worker policy"

  policy = file("policy.json")
}

resource "aws_iam_role" "jenkins_role" {
  name = "jenkins-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = "RoleForEC2"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "jenkins_attach_policy" {
  name       = "jenkins-attach-policy"
  roles      = [aws_iam_role.jenkins_role.name]
  policy_arn = aws_iam_policy.jenkins_policy.arn
}

resource "aws_iam_instance_profile" "jenkins_instance_profile" {
  name = "jenkins-instance-profile"
  role = aws_iam_role.jenkins_role.name
}