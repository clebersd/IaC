
terraform {
  
  required_providers {
    
    libvirt = {

      source = "dmacvicar/libvirt"
      version = "0.8.3"
      
    }

  }

}


provider "libvirt" {
  
  uri =  "qemu:///system"

}


resource "libvirt_pool" "storage"{
  name = "storage"

  type = "dir" 

  target {

    path = "/home/reis/storage"
  }

}

resource "libvirt_volume" "debian" {
 
  name = "debian13.qcow2"
 
  pool = libvirt_pool.storage.name
 
  source = "https://cloud.debian.org/images/cloud/trixie/20260601-2496/debian-13-generic-amd64-20260601-2496.qcow2"

}


resource "libvirt_volume" "host0" {
  
  name = "host0.qcow2"
  
  base_volume_id = libvirt_volume.debian.id

}

resource "libvirt_volume" "host1" {
  
  name = "host1.qcow2"
  
  base_volume_id = libvirt_volume.debian.id

}


resource "libvirt_volume" "host2" {
  
  name = "host2.qcow2"
  
  base_volume_id = libvirt_volume.debian.id

}


resource "libvirt_volume" "host3" {
  
  name = "host3.qcow2"
  
  base_volume_id = libvirt_volume.debian.id

}

resource "libvirt_cloudinit_disk" "commoninit"{

  name = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
  meta_data = data.template_file.meta_data.rendered
  
}

data "template_file" "user_data" {
  template = file("./cloud_init.cfg")

}

data "template_file" "meta_data" {
  template = file("./cloud_init_meta.cfg")

}

resource "libvirt_network" "net" {
  name = "inet"
  mode = "nat"
  domain = "reis.local"
  addresses = ["192.168.1.0/24"]
  dhcp {

      enabled = true

  }
}

resource "libvirt_domain" "host0" {

  name = "host0"
  vcpu = 2
  memory = 1024
  type = "kvm"
  disk {

    volume_id = libvirt_volume.host0.id

  }
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {

    network_id = libvirt_network.net.id
    hostname = "host0"
    addresses = ["192.168.1.5"]
    
  }

}



resource "libvirt_domain" "host1" {

  name = "host1"
  vcpu = 2
  memory = 1024
  type = "qemu"
  disk {

    volume_id = libvirt_volume.host1.id

  }
  network_interface {

    network_id = libvirt_network.net.id
    hostname = "host1"
    addresses = ["192.168.1.6"]
    
  }
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

}

resource "libvirt_domain" "host2" {

  name = "host2"
  vcpu = 2
  memory = 1024
  type = "qemu"
  disk {

    volume_id = libvirt_volume.host2.id

  }

  network_interface {

    network_id = libvirt_network.net.id
    hostname = "host2"
    addresses = ["192.168.1.7"]
    
  }
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

}


resource "libvirt_domain" "host3" {

  name = "host3"
  vcpu = 2
  memory = 1024
  type = "qemu"
  disk {

    volume_id = libvirt_volume.host3.id

  }
  network_interface {

    network_id = libvirt_network.net.id
    hostname = "host3"
    addresses = ["192.168.1.8"]
    
  }
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

}

