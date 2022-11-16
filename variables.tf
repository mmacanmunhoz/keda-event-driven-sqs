variable "cluster_name" {
  default = "keda-eks"
}

variable "region" {
  default = "us-east-2"
}

variable "kubernetes_version" {
  default = "1.22"
}

variable "desired_size" {
  default = 1
}

variable "min_size" {
  default = 0
}

variable "max_size" {
  default = 1
}