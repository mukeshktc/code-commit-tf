resource "aws_codecommit_repository" "test" {
  repository_name = var.myrepo
  description     = "${var.myrepo} repository to learn"
}
resource "aws_iam_user_policy" "cc_user_policy" {
  name = "vpro-cc-policy"
  user = aws_iam_user.cc.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "codecommit:ListRepositoriesForApprovalRuleTemplate",
                "codecommit:CreateApprovalRuleTemplate",
                "codecommit:UpdateApprovalRuleTemplateName",
                "codecommit:GetApprovalRuleTemplate",
                "codecommit:ListApprovalRuleTemplates",
                "codecommit:DeleteApprovalRuleTemplate",
                "codecommit:ListRepositories",
                "codecommit:UpdateApprovalRuleTemplateContent",
                "codecommit:UpdateApprovalRuleTemplateDescription"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": "codecommit:*",
            "Resource": aws_codecommit_repository.test.arn
        }
    ]
})
}

resource "aws_iam_user" "cc" {
  name = "vpro-user"
}

resource "aws_iam_user_ssh_key" "user" {
  username   = aws_iam_user.cc.name
  encoding   = "SSH"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDT6eImlo005eDNsOYxTEkR986H6hO9xuvgcQDAiK7T5wu6u+Y5j+RkmeliTKG/YqFb3eSz0nkj2K3BfdSgU2wTOxcEIxySpvT71vXayj61LokzEeVBq+GmMDALcEKv2oG3Eq12FuiFpUKU0VczUb6SDbsPVQEA7mOGCRIy55N/VNS6Ki/ImcBpN1W+qc+Me78v6W+CGN91rpJhX2k+PzPed1D9sClHCLtJDmzyaZXgDOeIBnapY5Qs4l6eCneGoa7sHp8e8y0HgM+vxxuRqj37CpI7UnE1z2gP4iCIfsrSeFdV2eQAkzYoFdbjg7IzF+EPzwxCLp6RRb59YSPBu6Ny0CIkHV9dc/AuBlGts07WQF9hYruQaYhydvvg+Ivi8IUMI91aCUdYsrAKbXEpKFqHdNlcAtf6fofe0HEwTxCVjbfeOiEBeBGuKDP09z3FGoXWvA6USFSFV0OyAYZybhmgOhuZnZdlpvCyVU7IGak5GhQGTKSs6EWsuHm3aiytWfM= mukesh@mukesh"

  provisioner "local-exec" {
    command = "echo ${self.ssh_public_key_id} > ssh_pk_id.txt"
  }
}

