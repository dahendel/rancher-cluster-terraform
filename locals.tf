locals {
  etcd_node_templates = {
    for k, v in data.aws_subnet.subnets :
    "${data.aws_vpc.vpc.tags["Name"]}-${v["availability_zone"]}-${length(regexall("private", v["tags"]["Name"])) > 0 ? "private" : "public"}-etcd" => {
      zone      = v["availability_zone_id"]
      subnet_id = k
      private   = length(regexall("private", v["tags"]["Name"])) > 0 ? true : false
    }
  }

  cp_node_templates = {
    for k, v in data.aws_subnet.subnets :
    "${data.aws_vpc.vpc.tags["Name"]}-${v["availability_zone"]}-${length(regexall("private", v["tags"]["Name"])) > 0 ? "private" : "public"}-cp" => {
      zone      = v["availability_zone_id"]
      subnet_id = k
      private   = length(regexall("private", v["tags"]["Name"])) > 0 ? true : false
    }
  }

  worker_node_templates = {
    for k, v in data.aws_subnet.subnets :
    "${data.aws_vpc.vpc.tags["Name"]}-${v["availability_zone"]}-${length(regexall("private", v["tags"]["Name"])) > 0 ? "private" : "public"}-wkr" => {
      zone      = v["availability_zone_id"]
      subnet_id = k
      private   = length(regexall("private", v["tags"]["Name"])) > 0 ? true : false
    }
  }

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