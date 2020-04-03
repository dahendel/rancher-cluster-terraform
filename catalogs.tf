resource "rancher2_catalog" "catalogs" {
  for_each = var.catalogs
  name     = each.key
  url      = each.value["url"]
  branch   = each.value["branch"] != "" ? each.value["branch"] : "master"
  scope    = lookup(each.value, "scope", "global")
  username = lookup(each.value, "username", "")
  password = lookup(each.value, "password", "")
  project_id = lookup(each.value, "scope", "") == "project" ? rancher2_project.projects[lookup(each.value, "project")].id :  ""
  cluster_id = lookup(each.value, "scope", "") == "cluster" ? rancher2_cluster.cluster.id : ""
  refresh = true
}
