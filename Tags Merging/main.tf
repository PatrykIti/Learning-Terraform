provider "azurerm" {
  version = "~> 2.18"
  features {}
}

locals {
  tags_default = {
    "environment"   = "Web"
    "department"    = "IT Department"
    "project"       = "Migration"
    "starting date" = "14/01/2020"
    "owner"         = "Patryk Ciechanski"
    "partner"       = "Jan Nowak (example)"
  }

  tags_net = {
    "environment" = "Networking"
    "department"  = "Networking Department"
    "partner"     = "Miroslaw Drop (example)"

  }

  tags_stor = {
    "environment" = "Storage"
    "partner"     = "Zbigniew Kowalski (example)"
  }

  location = "northeurope"
}

module "networking" {
  source   = "./modules/networking"
  location = local.location
  tags     = "${merge(local.tags_default, local.tags_net)}"
}

module "storage" {
  source   = "./modules/storage"
  location = local.location
  tags     = "${merge(local.tags_default, local.tags_stor)}"
}