
resource "rancher2_cluster" "cluster" {
  name = var.cluster_name
  description = "Rancher ${var.cluster_name}"
  cluster_template_id = data.rancher2_cluster_template.this.id
  cluster_template_revision_id = data.rancher2_cluster_template.this.template_revisions[0].id
  enable_cluster_alerting = true
  enable_cluster_monitoring = true
  cluster_monitoring_input {
    answers = {
      "exporter-kubelets.https" = true
      "exporter-node.enabled" = true
      "exporter-node.ports.metrics.port" = 9796
      "exporter-node.resources.limits.cpu" = "200m"
      "exporter-node.resources.limits.memory" = "200Mi"
      "grafana.persistence.enabled" = false
      "grafana.persistence.size" = "10Gi"
      "grafana.persistence.storageClass" = "default"
      "operator.resources.limits.memory" = "500Mi"
      "prometheus.persistence.enabled" = "true"
      "prometheus.persistence.size" = "50Gi"
      "prometheus.persistence.storageClass" = "default"
      "prometheus.persistent.useReleaseName" = "true"
      "prometheus.resources.core.limits.cpu" = "1000m",
      "prometheus.resources.core.limits.memory" = "1500Mi"
      "prometheus.resources.core.requests.cpu" = "750m"
      "prometheus.resources.core.requests.memory" = "750Mi"
      "prometheus.retention" = "72h"
    }
  }

  cluster_template_answers {
    values = {
      "rancherKubernetesEngineConfig.services.etcd.backupConfig.s3BackupConfig.folder" = var.cluster_name
    }
  }

  lifecycle {
    ignore_changes = [
      cluster_template_questions,
      description
    ]
  }
}

resource "rancher2_node_pool" "worker_pool" {
  cluster_id = rancher2_cluster.cluster.id
  hostname_prefix = "${var.cluster_name}-wkr"
  name = rancher2_node_template.worker_templates[keys(rancher2_node_template.worker_templates)[0]].name
  node_template_id = rancher2_node_template.worker_templates[keys(rancher2_node_template.worker_templates)[0]].id
  quantity = 1

  control_plane = false
  worker = true
  etcd = false

  lifecycle {
    ignore_changes = [
      quantity,
    ]
  }
}

resource "rancher2_node_pool" "etcd_pool" {
  cluster_id = rancher2_cluster.cluster.id
  hostname_prefix = "${var.cluster_name}-etcd"
  name = rancher2_node_template.etcd_templates[keys(rancher2_node_template.etcd_templates)[0]].name
  node_template_id = rancher2_node_template.etcd_templates[keys(rancher2_node_template.etcd_templates)[0]].id
  quantity = 1
  control_plane = false
  worker = false
  etcd = true
  lifecycle {
    ignore_changes = [
      quantity,
    ]
  }
}

resource "rancher2_node_pool" "controlplane_pool" {
  cluster_id = rancher2_cluster.cluster.id
  hostname_prefix = "${var.cluster_name}-cp"
  name = rancher2_node_template.controlplane_templates[keys(rancher2_node_template.controlplane_templates)[0]].name
  node_template_id = rancher2_node_template.controlplane_templates[keys(rancher2_node_template.controlplane_templates)[0]].id
  quantity = 1
  control_plane = true
  worker = false
  etcd = false
  lifecycle {
    ignore_changes = [
      quantity,
    ]
  }
}