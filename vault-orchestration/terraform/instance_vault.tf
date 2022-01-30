variable "project_id" {
  type        = string
  description = "L' ID de votre projet Scaleway."
}

variable "access_key" {
  type        = string
  description = "La clé API de votre projet Scaleway."
}

variable "secret_key" {
  type        = string
  description = "La clé secrète de votre projet Scaleway."
}

variable "image" {
  type        = string
  description = "L'ID de votre image packer."
}

terraform {
  required_providers {
    scaleway = {
      source = "scaleway/scaleway"
    }
  }
  required_version = ">= 0.13"
}

provider "scaleway" {
  zone   = "fr-par-1"
  region = "fr-par"
  access_key=var.access_key
  secret_key=var.secret_key
}

resource "scaleway_instance_ip" "public_ip" {
  project_id = var.project_id
}

resource "scaleway_instance_server" "vault" {
  project_id = var.project_id
  type       = "DEV1-S"
  image      = var.image

  ip_id = scaleway_instance_ip.public_ip.id
}
