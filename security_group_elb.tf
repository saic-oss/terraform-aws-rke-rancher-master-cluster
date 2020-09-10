resource "aws_security_group" "ingress_elb" {
  name        = "${module.label.id}-ingress-elb"
  description = "Security group for the ingress ELB"
  vpc_id      = var.vpc_id
  tags        = module.label.tags
}

resource "aws_security_group_rule" "ingress_elb_egress" {
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS007
  security_group_id = aws_security_group.ingress_elb.id
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_elb_port_http" {
  description       = "Allow HTTP traffic from everywhere"
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress_elb.id
  type              = "ingress"
}

resource "aws_security_group_rule" "ingress_elb_port_https" {
  description       = "Allow HTTPS traffic from everywhere"
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
  cidr_blocks       = ["0.0.0.0/0"] #tfsec:ignore:AWS006
  security_group_id = aws_security_group.ingress_elb.id
  type              = "ingress"
}
