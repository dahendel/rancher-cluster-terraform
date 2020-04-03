## Rancher RKE Cluster

This module is built from the [Rancher On-Boarding Guide](https://github.com/rancher/onboarding-content/tree/master)
It Builds clusters in AWS and enables the cloud_provider aws in the rke config

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| local | n/a |
| rancher2 | n/a |
| tls | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| cluster\_name | Rancher Cluster Name | `any` | n/a | yes |
| rancher\_token | Rancher API Token | `any` | n/a | yes |
| rancher\_url | Rancher management URL | `any` | n/a | yes |
| vpc\_id | VPC ID to deploy cluster to | `string` | n/a | yes |
| admin\_group\_id | Admin Group ID | `string` | `""` | no |
| ami\_image\_name | AMI Image for the node templates | `string` | `"ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"` | no |
| app\_certificates | Map of Maps to create application tls certificates.<br><br>  Key: Certificate secret name ex. awx-cert<br><br>  Values:<br>    - `org:` Organization Name (required)<br>    - `cn:` Common Name (required)<br>    - `dns_names:` List of DNS Names (required)<br>    - `validity_period:` Integer validity period in hours (optional) (default: 4800)<br>    - `project:` Valid project from projects map (required)<br><br>  Example:<pre>  app_certificates = {<br>    awx-cert = {<br>      org = Bridge Connector<br>      project = DevOps<br>      cn = awx.bcrdev.us<br>      validity_period = 4800<br>      dns_names = [<br>        awx-bcrdev.us,<br>        ansible.bcrdev.us<br>      ]<br>    }<br>  }<br>  </pre> | `map` | `{}` | no |
| catalogs | Map of Maps to add Catalogs<br><br>  Key: Catalog Name awx<br><br>  Values:<br>    - `url:` Catalog git compatible URL (required)<br>    - `branch:` Git branch (optional)<br>    - `scope:` Global, Cluster, Project scope (optional) (default: global)<br>    - `project:` Project to add the catalog to (optional/required with scope=project)<br>    - `username:` Username to use when cloning helm repository (optional)<br>    - `password:` Password for helm repo user (optional)<br><br>  Example:<pre>  catalogs = {<br>    awx = {<br>      url = "20m"<br>    }<br>  }<br>  </pre> | `map` | `{}` | no |
| cloud\_credential\_id | Cloud Crecdential from rancher-ha module | `string` | `""` | no |
| controlplane\_instance\_type | Control Plane instance type based on master and master components recomendations: https://kubernetes.io/docs/setup/best-practices/cluster-large/#size-of-master-and-master-components | `string` | `"m3.large"` | no |
| controlplane\_tags | Control plane node tags | `map(string)` | `{}` | no |
| controlplane\_volume\_size | Control Plane volume size | `string` | `"50"` | no |
| default\_apps | Map of Maps to deploy default applications to new cluster.<br><br>  Key: Name of the app from app catalog ex. filebeat.<br><br>  Values:<br>    - `namespace:` Valid namespace name from namespace map (required)<br>    - `project`:  Valid project from projects map (required)<br>    - `values:`   Filepath to values.yml (optional)<br>    - `answers:` Map of answers for template (optional)<br><br>  Example:<pre>  default_apps = {<br>    filebeat {<br>      namespace = filebeat<br>      project = DevOps<br>      values = files/filebeat.values.yml<br>    }<br>  }<br>  </pre> | `map` | `{}` | no |
| env | Rancher K8s Cluster Environment Tag | `string` | `""` | no |
| etcd\_instance\_type | Etcd instance type, default based on etcd hardware configurations: https://etcd.io/docs/v3.4.0/op-guide/hardware/ | `string` | `"m4.large"` | no |
| etcd\_tags | ETCD node tags | `map(string)` | `{}` | no |
| etcd\_volume\_size | ETCD node volume size | `string` | `"50"` | no |
| extra\_ssh\_keys | Extra SSH keys to pass to cloud-init file | `list(string)` | `[]` | no |
| instance\_profile | AWS Instance profile to use for node templates | `string` | `"Rancher-AWS-Cluster"` | no |
| instance\_ssh\_user | SSH User | `string` | `"ubuntu"` | no |
| projects | Map of Maps to create projects<br><br>  Key: Project Name ex. DevOps<br><br>  Values:<br>    - `cpu:` CPU resource limit (optional)<br>    - `memory:` Memory resource limit (optional)<br>    - `storage:` Storage resource limit (optional)<br>    - `read_only_groups:` List of read only groups (optional)<br>    - `owner_groups:` List of read only groups (optional)<br>    - `namespaces:` Map of maps Key is namespace name and nested map contains namespace limits<br><br>  Example:<pre>  projects = {<br>    DevOps = {<br>      cpu = "20m"<br>      memory = "100mi"<br>      storage = "1gi"<br>      read_only_groups = ["ping_group://Rancher Read Only"]<br>      member_groups = ["ping_group://Rancher Project Members"]<br>      namespaces = {<br>        vault = {<br>          cpu = "20m"<br>          memory = "100mi"<br>          storage = "1gi"<br>        }<br>        awx = {<br>          cpu = "20m"<br>          memory = "100mi"<br>          storage = "1gi"<br>        }<br>      }<br>    }<br>  }<br>  </pre> | `map` | `{}` | no |
| rancher\_insecure | Rancher skip tls vazlidation | `bool` | `true` | no |
| region | AWS Region | `string` | `"us-east-1"` | no |
| worker\_instance\_type | AMI Instance type for worker nodes | `string` | `"t3.large"` | no |
| worker\_tags | Tags for worker nodes | `map(string)` | `{}` | no |
| worker\_volume\_size | Worker node volume size | `string` | `"50"` | no |

## Outputs

| Name | Description |
|------|-------------|
| certs | n/a |
| cp\_templates | n/a |
| etcd\_templates | n/a |
| namespaces | n/a |
| projects | n/a |
| worker\_templates | n/a |
