terraform { 

 required_providers { 
  arvan = { 
   source = "arvancloud.com/terraform/arvan" 
   version = "0.6.1" 
  } 
 } 
} 

variable "ApiKey" { 
 type = string 
 default = "Apikey ba26f923-1fe7-56ac-8f63-67db7ef7465e" 
 sensitive = true 
} 

provider "arvan" { 
 api_key = var.ApiKey 
} 

locals {
  masters = toset([
  "master1" 
  ])

  workers = toset([
  "worker1"
  ])

}


variable "region" { 
 type = string 
 default = "ir-thr-c2" # Forogh Datacenter 
} 

resource "arvan_iaas_subnet" "subnet-1" {
  region = var.region
  name = "subnet-1"
  subnet_ip = "192.168.0.0/24"
  enable_gateway = false
  gateway = "192.168.0.1"
    dns_servers = [
    "1.1.1.1",
    "9.9.9.9"
  ]
  enable_dhcp = true
  dhcp {
    from = "192.168.0.20"
    to = "192.168.0.200"
  }
}

output "subnet-details" {
  value = arvan_iaas_subnet.subnet-1
}

resource "arvan_iaas_abrak" "masters" { 
 depends_on = [ arvan_iaas_subnet.subnet-1 ]

 for_each = local.masters

 region = var.region 
 flavor = "g1-2-2-0" 
 name  = each.key 
 image { 
  type = "distributions" 
  name = "ubuntu/22.04" 
 } 
 disk_size = 25 
 ssh_key= true
 key_name="jump"
 ha_enabled = true
 networks = ["subnet-1"]
} 

resource "arvan_iaas_abrak" "workers" { 
 depends_on = [ arvan_iaas_subnet.subnet-1 ]
 for_each = local.workers

 name  = each.key 
 region = var.region 
 flavor = "g1-4-2-0" 
 image { 
  type = "distributions" 
  name = "ubuntu/22.04" 
 } 
 disk_size = 45 
 ssh_key= true
 key_name="jump"
 ha_enabled = true
 networks = ["subnet-1"]
} 

data "arvan_iaas_abrak" "get_abrak_id" {
  depends_on = [
    arvan_iaas_abrak.masters,
    arvan_iaas_abrak.workers
  ]

 for_each = setunion(local.masters, local.workers)
 name  = each.key 
 region = var.region
}

#resource "arvan_iaas_network_attach" "attach-network-abrak" {
#  depends_on = [
#    arvan_iaas_abrak.workers,
#    arvan_iaas_abrak.masters,
#    arvan_iaas_subnet.subnet-1
#  ]
#
#  for_each = setunion(local.masters, local.workers)
#  abrak_uuid = data.arvan_iaas_abrak.get_abrak_id[each.key].id
#  network_uuid = arvan_iaas_subnet.subnet-1.network_uuid
#  region = var.region
#}
