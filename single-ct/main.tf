terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url = var.proxmox_api_url
  pm_api_token_id = var.proxmox_api_token_id
  pm_api_token_secret = var.proxmox_api_token_secret
  pm_tls_insecure = true
}

resource "proxmox_lxc" "LXC" {
  target_node = "pve-backup"
  vmid = 100
  hostname = "CT-Ubuntu" 
  ostemplate = "local:vztmpl/ubuntu-22.04-standard_22.04-1_amd64.tar.zst" // location and name of your template CT
  password = "password"
  unprivileged = true
  cores = 1
  memory = 512
  swap = 1024
  start = true
  
rootfs{
  storage = "hdd1" // storage for your ct
  size = "4G"
} 

network {
  name = "eth0"
  bridge = "vmbr0"
  ip = "dhcp"
}

lifecycle {
  ignore_changes = [ 
    network
   ]
}
}