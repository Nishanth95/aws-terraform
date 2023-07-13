resource "null_resource" "genpolicy" {
  count = var.condition ? 1 : 0

  triggers = {
    always_run = timestamp()
  }

  provisioner "local-exec" {
    command = "bash generatepolicy.sh ${var.ticket} ${var.services} ${var.permrequired} ${var.resourcearn}"
  }
}
data "local_file" "policy_file" {
  depends_on = [null_resource.genpolicy]
  count       = fileexists("${path.root}/${var.ticket}-policy.json") ? 1 : 0
  filename   = "${path.root}/${var.ticket}-policy.json"

}

resource "aws_iam_role" "globe_role" {
  name               = var.role_name
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "${var.assume_service}.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_policy" "globepolicy" {
  count       = fileexists("${path.root}/${var.ticket}-policy.json") ? 1 : 0
  depends_on  = [null_resource.genpolicy]
  name        = "${var.ticket}-policy"
  description = "Terraform Managed IAM policy"
  policy      =  data.local_file.policy_file[0].content
}

resource "aws_iam_policy_attachment" "globe_policy_attachment" {
  count      = fileexists("${path.root}/${var.ticket}-policy.json") ? 1 : 0  
  name       = "globe_policy"
  policy_arn =  aws_iam_policy.globepolicy[0].arn
  roles      = [aws_iam_role.globe_role.name]

  depends_on = [
    aws_iam_role.globe_role,
    aws_iam_policy.globepolicy
  ]
}
resource "aws_iam_policy_attachment" "managed_policy_attachments" {
  for_each   = toset(var.managed_policy_arn)
  policy_arn = each.value
  name       = "AWS-Managed-Policy"
  roles      = [aws_iam_role.globe_role.name]
}

resource "null_resource" "delete_policy_file" {
    count      = fileexists("${path.root}/${var.ticket}-policy.json") ? 1 : 0
  provisioner "local-exec" {
    command    = "rm ${path.root}/${var.ticket}-policy.json"
  }

  depends_on = [
    aws_iam_policy_attachment.globe_policy_attachment,
    aws_iam_policy.globepolicy
  ]
}
