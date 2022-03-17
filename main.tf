##-----------------------------------------------------------------------------
# name:     vpc_dhcp_options
# version:  12.0.0
# provider: aws
##-----------------------------------------------------------------------------

##-----------------------------------------------------------------------------
# Terraform
terraform {
  required_version = "~> 0.12.20"
  required_providers {
    null = "~> 2.1"
    aws  = "~> 3.35"
  }
}

##-----------------------------------------------------------------------------
# Providers
provider "aws" {
  alias = "this"
}

##-----------------------------------------------------------------------------
# Data
data "aws_region" "this" {
  provider = aws.this
}

data "aws_caller_identity" "this" {
  provider = aws.this
}

##-----------------------------------------------------------------------------
# Variables
variable "details" {
  description = "Details"
  default = {
    scope            = ""
    scope_abbr       = ""
    purpose          = ""
    purpose_abbr     = ""
    environment      = ""
    environment_abbr = ""
    additional_tags  = {}
  }
}

##-----------------------------------------------------------------------------
# Validation
resource "null_resource" "validation-details-scope" {
  count = (lookup(var.details, "scope", "") != "" ? 0 : "invalid") # ERROR: Scope not specified
}

resource "null_resource" "validation-details-purpose" {
  count = (lookup(var.details, "purpose", "") != "" ? 0 : "invalid") # ERROR: Purpose not specified
}

resource "null_resource" "validation-details-environment" {
  count = (lookup(var.details, "environment", "") != "" ? 0 : "invalid") # ERROR: Environment not specified
}

##-----------------------------------------------------------------------------
# Locals
locals {
  scope = {
    name    = var.details.scope
    abbr    = (can(var.details.scope_abbr) ? var.details.scope_abbr : lower(replace(replace(var.details.scope, "/[^0-9A-Za-z]/", " "), "/\\s{1,}/", "_")))
    machine = (can(var.details.scope_abbr) ? replace(var.details.scope_abbr, "/[^0-9A-Za-z]/", "") : lower(replace(var.details.scope, "/[^0-9A-Za-z]/", "")))
  }

  purpose = {
    name    = var.details.purpose
    abbr    = (can(var.details.purpose_abbr) ? var.details.purpose_abbr : lower(replace(replace(var.details.purpose, "/[^0-9A-Za-z]/", " "), "/\\s{1,}/", "_")))
    machine = (can(var.details.purpose_abbr) ? replace(var.details.purpose_abbr, "/[^0-9A-Za-z]/", "") : lower(replace(var.details.purpose, "/[^0-9A-Za-z]/", "")))
  }

  environment = {
    name    = var.details.environment
    abbr    = (can(var.details.environment_abbr) ? var.details.environment_abbr : lower(replace(replace(var.details.environment, "/[^0-9A-Za-z]/", " "), "/\\s{1,}/", "_")))
    machine = (can(var.details.environment_abbr) ? replace(var.details.environment_abbr, "/[^0-9A-Za-z]/", "") : lower(replace(var.details.environment, "/[^0-9A-Za-z]/", "")))
  }

  additional_tags = (try(var.details.additional_tags, {}))

  tags = merge(
    map(
      "Scope", local.scope.name,
      "Purpose", local.purpose.name,
      "Environment", local.environment.name,
    ),
    local.additional_tags
  )

  aws = {
    account = {
      id = data.aws_caller_identity.this.account_id
    }
    region = {
      name        = data.aws_region.this.name
      abbr        = local.lookup.region.abbr["${data.aws_region.this.name}"]
      description = data.aws_region.this.description
    }
  }

  lookup = {
    region = {
      abbr = {
        ap-east-1      = "ape1"
        ap-northeast-1 = "apne1"
        ap-northeast-2 = "apne2"
        ap-south-1     = "aps1"
        ap-southeast-1 = "apse1"
        ap-southeast-2 = "apse2"
        ca-central-1   = "cac1"
        eu-central-1   = "euc1"
        eu-north-1     = "eun1"
        eu-west-1      = "euw1"
        eu-west-2      = "euw2"
        eu-west-3      = "euw3"
        me-south-1     = "mes1"
        sa-east-1      = "sae1"
        us-east-1      = "use1"
        us-east-2      = "use2"
        us-west-1      = "usw1"
        us-west-2      = "usw2"
        us-gov-east-1  = "uge1"
        us-gov-west-1  = "ugw1"
      }
    }
  }
}
