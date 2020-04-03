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

  project_limit_defaults = {
    cpu = "2000m"
    memory = "2000Mi"
    stroage = "2Gi"
  }

  namespacs_limit_defaults = {
    cpu = "2000m"
    memory = "500Mi"
    stroage = "1Gi"
  }

  container_limit_defaults = {
    cpu = "20m"
    reqs_cpu = "1m"
    memory = "20mi"
    reqs_mem = "1Mi"
  }

}