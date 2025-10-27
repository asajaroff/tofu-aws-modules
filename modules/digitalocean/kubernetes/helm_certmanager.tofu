resource "kubernetes_secret" "certmanager_aws_credentials" {
  metadata {
    name      = "aws-route53-credentials"
    namespace = "cert-manager"
  }

  data = {
    access-key-id     = aws_iam_access_key.certmanager.id
    secret-access-key = aws_iam_access_key.certmanager.secret
  }

  type = "Opaque"

  depends_on = [helm_release.cert-manager]
}

resource "helm_release" "cert-manager" {
  name        = "tofu"
  namespace   = "cert-manager"
  chart = "oci://quay.io/jetstack/charts/cert-manager"
  version     = "v1.19.1"

  create_namespace = true

  set {
    name  = "crds.enabled"
    value = "true"
  }


  values = [ <<EOV

config: {}
dns01RecursiveNameservers: ""
dns01RecursiveNameserversOnly: false
disableAutoApproval: false
approveSignerNames:
- issuers.cert-manager.io/*
- clusterissuers.cert-manager.io/*

EOV
  ]

  depends_on = [digitalocean_kubernetes_cluster.this]
}

data "aws_iam_policy_document" "certmanager" {
  statement {
    sid = "1"

    effect = "Allow"
    actions = [
      "route53:GetChange",
    ]
    resources = [
      "arn:aws:route53:::change/*",
    ]
  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ChangeResourceRecordSets",
      "route53:ListResourceRecordSets",
    ]

    resources = [
      "arn:aws:route53:::hostedzone/${var.hosted_zone}",
    ]
   condition {
     test     = "ForAllValues:StringEquals"
     variable = "route53:ChangeResourceRecordSetsRecordTypes"
     values   = ["TXT"]
   }

  }

  statement {
    effect = "Allow"
    actions = [
      "route53:ListHostedZonesByName",
    ]
    resources = [
      "*",
    ]
  }
}

resource "aws_iam_user" "certmanager" {
  name = "certmanager-digitalocean"
  path = "/system/"
}

resource "aws_iam_access_key" "certmanager" {
  user = aws_iam_user.certmanager.name
}

resource "aws_iam_user_policy" "certmanager" {
  name   = "certmanager"
  user   = aws_iam_user.certmanager.name
  policy = data.aws_iam_policy_document.certmanager.json
}

resource "kubernetes_manifest" "letsencrypt_clusterissuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "letsencrypt-prod"
    }
    spec = {
      acme = {
        server = var.letsencrypt_server
        email  = var.letsencrypt_email
        privateKeySecretRef = {
          name = "letsencrypt-account-key"
        }
        solvers = [
          {
            dns01 = {
              route53 = {
                region = var.aws_region
                accessKeyIDSecretRef = {
                  name = kubernetes_secret.certmanager_aws_credentials.metadata[0].name
                  key  = "access-key-id"
                }
                secretAccessKeySecretRef = {
                  name = kubernetes_secret.certmanager_aws_credentials.metadata[0].name
                  key  = "secret-access-key"
                }
              }
            }
          }
        ]
      }
    }
  }

  depends_on = [
    helm_release.cert-manager,
    kubernetes_secret.certmanager_aws_credentials
  ]
}
