resource "random_uuid" "aws_elb_postfix" {}

resource "aws_elb" "ingress" { #tfsec:ignore:AWS005

  // The format of the name here is complicated because the max length of ELB names is 32 chars and
  // using name_prefix adds 26 chars to the end, leaving only 6 chars for the prefix. This line is saying
  // that the prefix can be up to 24 chars and the rest gets a truncated uuid
  name = substr(format("%s-%s", format("%.23s", module.label.id), replace(random_uuid.aws_elb_postfix.result, "-", "")), 0, 32)

  subnets         = distinct([var.node_group_1_subnet_id, var.node_group_2_subnet_id, var.node_group_3_subnet_id])
  security_groups = [aws_security_group.ingress_elb.id]
  listener {
    instance_port     = 80
    instance_protocol = "tcp"
    lb_port           = 80
    lb_protocol       = "tcp"
  }
  listener {
    instance_port     = 443
    instance_protocol = "tcp"
    lb_port           = 443
    lb_protocol       = "tcp"
  }
  health_check {
    healthy_threshold   = 2
    interval            = 5
    target              = "HTTP:80/healthz"
    timeout             = 2
    unhealthy_threshold = 2
  }
  instances    = concat(tolist(aws_instance.node_group_1.*.id), tolist(aws_instance.node_group_2.*.id), tolist(aws_instance.node_group_3.*.id))
  idle_timeout = 1800
}
