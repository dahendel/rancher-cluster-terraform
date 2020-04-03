output "worker_templates" {
  value = rancher2_node_template.worker_templates
  sensitive = true
}

output "etcd_templates" {
  value = rancher2_node_template.etcd_templates
  sensitive = true
}

output "cp_templates" {
  value = rancher2_node_template.controlplane_templates
  sensitive = true
}

output "certs" {
  value = tls_self_signed_cert.certs
  sensitive = true
}

output "namespaces" {
  value = rancher2_namespace.namespaces
  sensitive = true
}

output "projects" {
  value = rancher2_project.projects
  sensitive = true
}
