locals {
  ro_mappings = flatten([
    for k, v in var.projects: {
      for g in v["read_only_groups"]:
        g => {
          project = k
        }
    }
  ])

  member_mappings = flatten([
    for k, v in var.projects: {
      for g in v["member_groups"]:
        g => {
          project = k
        }
    }
  ])

  namespaces = flatten([
    for k, v in var.projects:[
      for nsk, nsv in v["namespaces"]: {
            namespace = nsk
            project = k
            cpu = lookup(nsv, "cpu", "")
            memory =  lookup(nsv, "memory", "")
            storage =  lookup(nsv, "storage", "")
    }]
  ])

}



resource "rancher2_project" "projects" {
  depends_on = [
    rancher2_node_pool.controlplane_pool,
    rancher2_node_pool.etcd_pool,
    rancher2_node_pool.worker_pool
  ]

  for_each = var.projects

  cluster_id = rancher2_cluster.cluster.id
  name = each.key
  wait_for_cluster = true
  resource_quota {
    project_limit {
      limits_cpu = lookup(each.value, "cpu", "" )
      limits_memory = lookup(each.value, "memory", "" )
      requests_storage = lookup(each.value, "storage", "" )
    }
    namespace_default_limit {}
  }
}


resource "rancher2_namespace" "namespaces" {
  depends_on = [
    rancher2_project.projects
  ]

  for_each = {
    for n in local.namespaces:
        n["namespace"] => n
  }
  name = each.key
  project_id = rancher2_project.projects[each.value.project].id
  resource_quota {
    limit {
      limits_cpu = each.value.cpu
      limits_memory = each.value.memory
      requests_storage = each.value.storage
    }
  }
  wait_for_cluster = true
}

resource "rancher2_cluster_role_template_binding" "cluster_owner" {
  depends_on = [
    rancher2_project.projects
  ]
  count = var.admin_group_id != "" ? 1 : 0
  name = "admin-group-binding"
  role_template_id = "cluster-owner"
  group_id = var.admin_group_id
  cluster_id = rancher2_cluster.cluster.id
}

resource "rancher2_project_role_template_binding" "project_ro" {
  depends_on = [
    rancher2_project.projects
  ]
  for_each = tomap(local.ro_mappings[0])
  name = lower(replace(replace(each.key, "/.*:\\/\\//", ""), " ", "-"))
  project_id = rancher2_project.projects[each.value["project"]].id
  role_template_id = "read-only"
  group_id = each.key
}

resource "rancher2_project_role_template_binding" "project_members" {
  depends_on = [
    rancher2_project.projects
  ]
  for_each = tomap(local.member_mappings[0])
  name = lower(replace(replace(each.key, "/.*:\\/\\//", ""), " ", "-"))
  project_id = rancher2_project.projects[each.value["project"]].id
  role_template_id = "project-member"
  group_id = each.key
}
