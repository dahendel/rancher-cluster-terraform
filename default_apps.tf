resource "rancher2_app" "apps" {
  depends_on = [
    rancher2_cluster.cluster,
    rancher2_project.projects,
    rancher2_namespace.namespaces
  ]

  for_each = var.default_apps
  catalog_name = each.value["catalog"]
  name = each.key
  project_id = rancher2_project.projects[each.value["project"]].id
  target_namespace = rancher2_namespace.namespaces[each.value["namespace"]].id
  template_name = each.key
  answers = lookup(each.value, "answers", {})
  values_yaml = lookup(each.value, "values", "") != "" ? base64encode(file(each.value["values"])) : ""
}