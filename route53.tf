resource "aws_route53_record" "rancher" {
  name    = local.rancher_fqdn
  type    = "A"
  zone_id = var.hosted_zone_id
  alias {
    evaluate_target_health = true
    name                   = aws_elb.ingress.dns_name
    zone_id                = aws_elb.ingress.zone_id
  }
}
