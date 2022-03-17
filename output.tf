output "metadata" {
  description = "Metadata"
  value = {
    details = {
      scope = {
        name    = local.scope.name
        abbr    = local.scope.abbr
        machine = local.scope.machine
      }
      purpose = {
        name    = local.purpose.name
        abbr    = local.purpose.abbr
        machine = local.purpose.machine
      }
      environment = {
        name    = local.environment.name
        abbr    = local.environment.abbr
        machine = local.environment.machine
      }
      tags = local.tags
    }

    aws = {
      account = {
        id = local.aws.account.id
      }
      region = {
        name        = local.aws.region.name
        abbr        = local.aws.region.abbr
        description = local.aws.region.description
      }
    }

    vpc_dhcp_options = {
      id                   = aws_vpc_dhcp_options.this.id
      arn                  = aws_vpc_dhcp_options.this.arn
      domain_name          = aws_vpc_dhcp_options.this.domain_name
      domain_name_servers  = aws_vpc_dhcp_options.this.domain_name_servers
      ntp_servers          = aws_vpc_dhcp_options.this.ntp_servers
      netbios_name_servers = aws_vpc_dhcp_options.this.netbios_name_servers
      netbios_node_type    = aws_vpc_dhcp_options.this.netbios_node_type
    }
  }
}
