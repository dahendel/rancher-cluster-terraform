variable "region" {
  description = "AWS Region"
  default     = "us-east-1"
  type        = string
}

variable "cluster_name" {
  description = "Rancher Cluster Name"
}

variable "ami_image_name" {
  description = "AMI Image for the node templates"
  default = "ubuntu-minimal/images/*/ubuntu-bionic-18.04-*"
}

variable "rancher_url" {
  description = "Rancher management URL"
}
variable "rancher_insecure" {
  type        = bool
  description = "Rancher skip tls vazlidation"
  default     = true
}
variable "rancher_token" {
  description = "Rancher API Token"
}

variable "extra_ssh_keys" {
  description = "Extra SSH keys to pass to cloud-init file"
  type        = list(string)
  default     = []
}

variable "controlplane_instance_type" {
  description = "Control Plane instance type based on master and master components recomendations: https://kubernetes.io/docs/setup/best-practices/cluster-large/#size-of-master-and-master-components"
  default     = "m3.large"
}

variable "controlplane_volume_size" {
  description = "Control Plane volume size"
  default     = "50"
}

variable "controlplane_tags" {
  description = "Control plane node tags"
  type        = map(string)
  default     = {}
}

variable "etcd_instance_type" {
  description = "Etcd instance type, default based on etcd hardware configurations: https://etcd.io/docs/v3.4.0/op-guide/hardware/"
  default     = "m4.large"
}

variable "etcd_tags" {
  description = "ETCD node tags"
  type        = map(string)
  default     = {}
}

variable "etcd_volume_size" {
  description = "ETCD node volume size"
  default     = "50"
}

variable "worker_instance_type" {
  description = "AMI Instance type for worker nodes"
  default     = "t3.large"
}

variable "worker_volume_size" {
  description = "Worker node volume size"
  default     = "50"
}

variable "worker_tags" {
  description = "Tags for worker nodes"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID to deploy cluster to"
  type        = string
}

variable "instance_ssh_user" {
  description = "SSH User"
  default     = "ubuntu"
}

variable "instance_profile" {
  description = "AWS Instance profile to use for node templates"
  default     = "Rancher-AWS-Cluster"
}

variable "cloud_credential_id" {
  description = "Cloud Crecdential from rancher-ha module"
  default = ""
}

variable "env" {
  description = "Rancher K8s Cluster Environment Tag"
  default = ""
}

variable "catalogs" {
  type        = map
  default     = {}
  description = <<EOF
  Map of Maps to add Catalogs

  Key: Catalog Name awx

  Values:
    - `url:` Catalog git compatible URL (required)
    - `branch:` Git branch (optional)
    - `scope:` Global, Cluster, Project scope (optional) (default: global)
    - `project:` Project to add the catalog to (optional/required with scope=project)
    - `username:` Username to use when cloning helm repository (optional)
    - `password:` Password for helm repo user (optional)

  Example:
  ```
  catalogs = {
    awx = {
      url = "20m"
    }
  }
  ```
EOF
}

variable "projects" {
  type = map
  default = {}
  description = <<EOF
  Map of Maps to create projects

  Key: Project Name ex. DevOps

  Values:
    - `cpu:` CPU resource limit (optional)
    - `memory:` Memory resource limit (optional)
    - `storage:` Storage resource limit (optional)
    - `read_only_groups:` List of read only groups (optional)
    - `owner_groups:` List of read only groups (optional)
    - `namespaces:` Map of maps Key is namespace name and nested map contains namespace limits

  Example:
  ```
  projects = {
    DevOps = {
      cpu = "20m"
      memory = "100mi"
      storage = "1gi"
      read_only_groups = ["ping_group://Rancher Read Only"]
      member_groups = ["ping_group://Rancher Project Members"]
      namespaces = {
        vault = {
          cpu = "20m"
          memory = "100mi"
          storage = "1gi"
        }
        awx = {
          cpu = "20m"
          memory = "100mi"
          storage = "1gi"
        }
      }
    }
  }
  ```
EOF
}


variable "app_certificates" {
  type = map
  default = {}
  description = <<EOF
  Map of Maps to create application tls certificates.

  Key: Certificate secret name ex. awx-cert

  Values:
    - `org:` Organization Name (required)
    - `cn:` Common Name (required)
    - `dns_names:` List of DNS Names (required)
    - `validity_period:` Integer validity period in hours (optional) (default: 4800)
    - `project:` Valid project from projects map (required)

  Example:
  ```
  app_certificates = {
    awx-cert = {
      org = My Org
      project = DevOps
      cn = awx.example.us
      validity_period = 4800
      dns_names = [
        awx.example.us
      ]
    }
  }
  ```
EOF
}

variable "default_apps" {
  type = map
  default = {}
  description = <<EOF
  Map of Maps to deploy default applications to new cluster.

  Key: Name of the app from app catalog ex. filebeat.

  Values:
    - `namespace:` Valid namespace name from namespace map (required)
    - `project`:  Valid project from projects map (required)
    - `values:`   Filepath to values.yml (optional)
    - `answers:` Map of answers for template (optional)

  Example:
  ```
  default_apps = {
    filebeat {
      namespace = filebeat
      project = DevOps
      values = files/filebeat.values.yml
    }
  }
  ```
EOF
}

variable "admin_group_id" {
  description = "Admin Group ID"
  default = ""
}
