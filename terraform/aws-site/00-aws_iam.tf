resource "aws_iam_user" "xc_user" {
  name = "${var.environment}-user"
  tags = {
    tag-key = "${var.environment}"
  }
}

resource "aws_iam_access_key" "xc_user" {
  user = aws_iam_user.xc_user.name

  depends_on = [ 
    aws_iam_user.xc_user
  ]
}

resource "aws_iam_user_policy_attachment" "xc_user" {
  user       = aws_iam_user.xc_user.name
  policy_arn = aws_iam_policy.xc_policy.arn

  depends_on = [ 
    aws_iam_policy.xc_policy
  ]
}

resource "aws_iam_policy" "xc_policy" {
  name        = "${var.environment}-policy"
  description = "F5 XC Cloud policy"
  policy = data.aws_iam_policy_document.xc_policy_document.json

  depends_on = [ 
    aws_iam_user.xc_user
  ]
}

data "aws_iam_policy_document" "xc_policy_document" {
  version = "2012-10-17"
  statement {
    sid = "AutoScalingPermissions"
    effect = "Allow"
    actions = [
      "autoscaling:AttachLoadBalancerTargetGroups",
      "autoscaling:AttachLoadBalancers",
      "autoscaling:CreateAutoScalingGroup",
      "autoscaling:CreateLaunchConfiguration",
      "autoscaling:DeleteAutoScalingGroup",
      "autoscaling:DeleteLaunchConfiguration",
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeLoadBalancerTargetGroups",
      "autoscaling:DescribeLoadBalancers",
      "autoscaling:DetachLoadBalancerTargetGroups",
      "autoscaling:DetachLoadBalancers",
      "autoscaling:DisableMetricsCollection",
      "autoscaling:EnableMetricsCollection",
      "autoscaling:ResumeProcesses",
      "autoscaling:SuspendProcesses",
      "autoscaling:UpdateAutoScalingGroup",
    ]
    resources = ["*"]
  }
  statement {
    sid = "EC2Permissions"
    effect = "Allow"
    actions = [
      "ec2:AllocateAddress",
      "ec2:AssignPrivateIpAddresses",
      "ec2:AssociateAddress",
      "ec2:AssociateIamInstanceProfile",
      "ec2:AssociateRouteTable",
      "ec2:AssociateSubnetCidrBlock",
      "ec2:AssociateVpcCidrBlock",
      "ec2:AttachInternetGateway",
      "ec2:AttachNetworkInterface",
      "ec2:AuthorizeSecurityGroupEgress",
      "ec2:AuthorizeSecurityGroupIngress",
      "ec2:CreateInternetGateway",
      "ec2:CreateNetworkInterface",
      "ec2:CreateRoute",
      "ec2:CreateRouteTable",
      "ec2:CreateSecurityGroup",
      "ec2:CreateSubnet",
      "ec2:CreateTags",
      "ec2:CreateVpc",
      "ec2:DeleteInternetGateway",
      "ec2:DeleteNetworkInterface",
      "ec2:DeleteRoute",
      "ec2:DeleteRouteTable",
      "ec2:DeleteSecurityGroup",
      "ec2:DeleteSubnet",
      "ec2:DeleteTags",
      "ec2:DeleteVpc",
      "ec2:DetachInternetGateway",
      "ec2:DetachNetworkInterface",
      "ec2:DisableVgwRoutePropagation",
      "ec2:DisassociateAddress",
      "ec2:DisassociateIamInstanceProfile",
      "ec2:DisassociateRouteTable",
      "ec2:DisassociateSubnetCidrBlock",
      "ec2:DisassociateVpcCidrBlock",
      "ec2:EnableVgwRoutePropagation",
      "ec2:ModifyInstanceAttribute",
      "ec2:ModifyInstanceCreditSpecification",
      "ec2:ModifyInstanceMetadataOptions",
      "ec2:ModifyNetworkInterfaceAttribute",
      "ec2:ModifySubnetAttribute",
      "ec2:ModifyVolume",
      "ec2:ModifyVpcAttribute",
      "ec2:ReleaseAddress",
      "ec2:ReplaceIamInstanceProfileAssociation",
      "ec2:ReplaceRoute",
      "ec2:ReplaceRouteTableAssociation",
      "ec2:RevokeSecurityGroupEgress",
      "ec2:RevokeSecurityGroupIngress",
      "ec2:RunInstances",
      "ec2:StartInstances",
      "ec2:StopInstances",
      "ec2:TerminateInstances",
      "ec2:UnassignPrivateIpAddresses",
      "ec2:UnmonitorInstances",
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeIamInstanceProfileAssociations",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceAttribute",
      "ec2:DescribeInstanceCreditSpecifications",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeNetworkAcls",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeRouteTables",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSubnets",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DescribeVolumesModifications",
      "ec2:DescribeVpcAttribute",
      "ec2:DescribeVpcClassicLink",
      "ec2:DescribeVpcClassicLinkDnsSupport",
      "ec2:DescribeVpcs",
      "ec2:GetPasswordData",
      "ec2:MonitorInstances",
    ]
    resources = ["*"]
  }
  statement {
    sid = "ELBPermissions"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup",
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:DeleteTargetGroup",
      "elasticloadbalancing:DeregisterTargets",
      "elasticloadbalancing:DescribeInstanceHealth",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeTags",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:RemoveTags",
    ]
    resources = ["*"]
  }
  statement {
    sid = "IAMPermissions"
    effect = "Allow"
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:AttachRolePolicy",
      "iam:CreateInstanceProfile",
      "iam:CreatePolicy",
      "iam:CreatePolicyVersion",
      "iam:CreateRole",
      "iam:CreateServiceLinkedRole",
      "iam:DeleteInstanceProfile",
      "iam:DeletePolicy",
      "iam:DeletePolicyVersion",
      "iam:DeleteRole",
      "iam:DeleteRolePermissionsBoundary",
      "iam:DeleteRolePolicy",
      "iam:DetachRolePolicy",
      "iam:GetInstanceProfile",
      "iam:GetPolicy",
      "iam:GetPolicyVersion",
      "iam:GetRole",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfilesForRole",
      "iam:ListPolicyVersions",
      "iam:ListRolePolicies",
      "iam:PassRole",
      "iam:PutRolePermissionsBoundary",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:TagRole",
      "iam:UpdateAssumeRolePolicy",
      "iam:UpdateRole",
      "iam:UpdateRoleDescription",
    ]
    resources = ["*"]
  }
}

output "aws_access_key_id" {
  value = aws_iam_access_key.xc_user.id
  description = "AWS AccessKey"
}

output "aws_access_key_secret" {
 value = aws_iam_access_key.xc_user.secret
 sensitive = true
 description = "AWS AccessSecret"
}