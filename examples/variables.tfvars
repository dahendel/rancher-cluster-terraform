"admin_group_id" = ""
"rancher_token" = ""
"rancher_url" = ""
"vpc_id" = ""
"catalogs" = {}
"cloud_credential_id" = ""
"cluster_name" = "bridge-utils"
"env" = ""

"instance_profile" = "Rancher-IP"
"projects" = {
  "DevOps" = {
    "member_groups" = []
    "namespaces" = {
      "chartmuseum" = {}
      "demo" = {}
    }
    "read_only_groups" = []
  }
}

"app_certificates" = {
  "chartmuseum-cert" = {
      "cn" = "charts.example.com"
      "dns_names" = [
        "charts.example.com"]
      "org" = "Demo"
      "project" = "DevOps"
      "validity_period" = 8760
  }
}

"default_apps" = {
  "chartmuseum" = {
      "catalog" = "library"
      "namespace" = "chartmuseum"
      "project" = "DevOps"
      "values" = "files/chartmuseum.values.yml"
  }
}
