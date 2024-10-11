# main.tf

resource "aws_iam_user" "this" {
  name = "${var.user_name}"
}

resource "aws_iam_policy" "this" {
  name        = "${var.user_name}"
  description = "${var.policy_description}"
  policy      = <<EOT
  {
    "Version": "2012-10-17",
    "Id": "{}",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "route53:ListHostedZones",
                "route53:GetChange"
            ],
            "Resource": [
                "*"
            ]
        },
        {
            "Effect" : "Allow",
            "Action" : [
                "route53:ChangeResourceRecordSets"
            ],
            "Resource" : [
                "arn:aws:route53:::hostedzone/Z0192398OCPJAU0SPUVV",
                "arn:aws:route53:::hostedzone/Z10113121729MJXO68N0G"
            ]
        }
    ]
}
EOT
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.this.name
  policy_arn = aws_iam_policy.this.arn
}
