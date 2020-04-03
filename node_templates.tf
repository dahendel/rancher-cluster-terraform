

resource "rancher2_node_template" "etcd_templates" {
  for_each                = local.etcd_node_templates
  name                    = each.key
  cloud_credential_id     = var.cloud_credential_id
  use_internal_ip_address = true
  amazonec2_config {
    ami            = data.aws_ami.ubuntu.id
    region         = var.region
    vpc_id         = var.vpc_id
    root_size      = var.etcd_volume_size
    zone           = substr(each.value["zone"], length(each.value["zone"]), 1)
    security_group = [aws_security_group.rancher.name]
    subnet_id      = each.value["subnet_id"]
    instance_type  = var.etcd_instance_type
    userdata = base64encode(templatefile("${path.module}/files/cloud-config.yaml", {
      extra_ssh_keys = concat(var.extra_ssh_keys, [tls_private_key.ssh.public_key_pem])
    }))
    iam_instance_profile = var.instance_profile
    ssh_user             = "ubuntu"
    tags                 = "k8srole,etcd,EC2KeyName,${aws_key_pair.ssh.key_name},EC2SSHUser,ubuntu,App,${var.env}"
    use_private_address  = each.value["private"]
    private_address_only = each.value["private"]
  }
}

resource "rancher2_node_template" "controlplane_templates" {
  for_each                = local.cp_node_templates
  name                    = each.key
  cloud_credential_id     = var.cloud_credential_id
  use_internal_ip_address = true

  amazonec2_config {
    ami            = data.aws_ami.ubuntu.id
    region         = var.region
    vpc_id         = var.vpc_id
    root_size      = var.controlplane_volume_size
    zone           = substr(each.value["zone"], length(each.value["zone"]), 1)
    security_group = [aws_security_group.rancher.name]
    subnet_id      = each.value["subnet_id"]
    instance_type  = var.controlplane_instance_type
    userdata = base64encode(templatefile("${path.module}/files/cloud-config.yaml", {
      extra_ssh_keys = concat(var.extra_ssh_keys, [tls_private_key.ssh.public_key_pem])
    }))
    iam_instance_profile = var.instance_profile
    ssh_user             = "ubuntu"
    tags                 = "k8srole,controlplane,EC2KeyName,${aws_key_pair.ssh.key_name},EC2SSHUser,ubuntu,App,${var.env}"
    use_private_address  = each.value["private"]
    private_address_only = each.value["private"]
  }
}

resource "rancher2_node_template" "worker_templates" {
  for_each                = local.worker_node_templates
  name                    = each.key
  cloud_credential_id     = var.cloud_credential_id
  use_internal_ip_address = true

  amazonec2_config {
    ami            = data.aws_ami.ubuntu.id
    region         = var.region
    vpc_id         = var.vpc_id
    root_size      = var.worker_volume_size
    zone           = substr(each.value["zone"], length(each.value["zone"]), 1)
    security_group = [aws_security_group.rancher.name]
    subnet_id      = each.value["subnet_id"]
    instance_type  = var.worker_instance_type
    userdata = base64encode(templatefile("${path.module}/files/cloud-config.yaml", {
      extra_ssh_keys = concat(var.extra_ssh_keys, [tls_private_key.ssh.public_key_pem])
    }))
    iam_instance_profile = var.instance_profile
    ssh_user             = "ubuntu"
    tags                 = "k8srole,worker,EC2KeyName,${aws_key_pair.ssh.key_name},EC2SSHUser,ubuntu,App,${var.env}"
    use_private_address  = each.value["private"]
    private_address_only = each.value["private"]
  }
}