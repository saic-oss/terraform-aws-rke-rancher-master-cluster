resource "aws_security_group" "nodes" {
  name        = "${module.label.id}-nodes"
  description = "Security group for RKE nodes"
  vpc_id      = var.vpc_id
  tags        = module.label.tags
}

resource "aws_security_group_rule" "nodes_egress" {
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.nodes.id
  type              = "egress"
}

resource "aws_security_group_rule" "nodes_ingress_self" {
  description       = "Allow all intra-security-group traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  self              = true
  security_group_id = aws_security_group.nodes.id
  type              = "ingress"
}

resource "aws_security_group_rule" "nodes_ingress_ssh" {
  description       = "Allow all SSH traffic"
  from_port         = 22
  to_port           = 22
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.nodes.id
  type              = "ingress"
}

resource "aws_security_group_rule" "nodes_ingress_k8s" {
  description       = "Allow all k8s API traffic"
  from_port         = 6443
  to_port           = 6443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.nodes.id
  type              = "ingress"
}

resource "aws_security_group_rule" "nodes_ingress_elb_80" {
  description              = "Allow HTTP traffic from the ELB"
  from_port                = 80
  to_port                  = 80
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.ingress_elb.id
  security_group_id        = aws_security_group.nodes.id
  type                     = "ingress"
}

resource "aws_security_group_rule" "nodes_ingress_elb_443" {
  description              = "Allow HTTPS traffic from the ELB"
  from_port                = 443
  to_port                  = 443
  protocol                 = "TCP"
  source_security_group_id = aws_security_group.ingress_elb.id
  security_group_id        = aws_security_group.nodes.id
  type                     = "ingress"
}
