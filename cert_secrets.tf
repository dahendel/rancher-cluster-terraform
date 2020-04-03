resource "tls_private_key" "keys" {
  for_each = var.app_certificates
  algorithm = "RSA"
}

resource "tls_self_signed_cert" "certs" {
  for_each = var.app_certificates
  key_algorithm   = "RSA"
  private_key_pem = tls_private_key.keys[each.key].private_key_pem
  is_ca_certificate = true
  dns_names = each.value["dns_names"]
  subject {
    common_name  = each.value["cn"]
    organization = each.value["org"]
  }

  validity_period_hours = lookup(each.value, "validity_period", 4800)
  early_renewal_hours = 72
  allowed_uses = [
    "key_encipherment",
    "digital_signature",
    "server_auth",
  ]
}

resource "rancher2_certificate" "certs" {
  for_each = var.app_certificates
  certs = base64encode(tls_self_signed_cert.certs[each.key].cert_pem)
  key = base64encode(tls_private_key.keys[each.key].private_key_pem)
  name = each.key
  project_id = rancher2_project.projects[each.value["project"]].id
}