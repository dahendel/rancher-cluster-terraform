data "aws_vpc" "vpc" {
  id = var.vpc_id
}

data "aws_subnet_ids" "subnet_ids" {
  vpc_id = data.aws_vpc.vpc.id
}

data "aws_subnet" "subnets" {
  for_each = data.aws_subnet_ids.subnet_ids.ids
  id       = each.key
}

data "rancher2_cluster_template" "this" {
  name = "default"
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = [
  "099720109477"]

  filter {
    name = "name"
    values = [
    var.ami_image_name]
  }

  filter {
    name = "virtualization-type"
    values = [
    "hvm"]
  }

  filter {
    name = "root-device-type"
    values = [
    "ebs"]
  }

  filter {
    name = "architecture"
    values = [
    "x86_64"]
  }
}