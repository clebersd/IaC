
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


resource "libvirt_volume" "ubuntu" {
 
  name = "ubunto.qcow2"
 
  pool = libvirt_pool.storage.name
 
  source = "https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"

}


resource "libvirt_volume" "host0" {
  
  name = "host0.qcow2"
  
  base_volume_id = libvirt_volume.ubuntu.id

}

resource "libvirt_volume" "host1" {
  
  name = "host1.qcow2"
  
  base_volume_id = libvirt_volume.ubuntu.id

}


resource "libvirt_volume" "host2" {
  
  name = "host2.qcow2"
  
  base_volume_id = libvirt_volume.ubuntu.id

}


resource "libvirt_volume" "host3" {
  
  name = "host3.qcow2"
  
  base_volume_id = libvirt_volume.ubuntu.id

}



resource "libvirt_cloudinit_disk" "commoninit"{

  name = "commoninit.iso"
  user_data = data.template_file.user_data.rendered
}

data "template_file" "user_data" {
  template = file("./cloud_init.cfg")

}



resource "libvirt_domain" "host0" {

  name = "host0"
  vcpu = 2
  memory = 1024
  type = "qemu"
  disk {

    volume_id = libvirt_volume.host0.id

  }
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

  network_interface {

    bridge = "br0"
    
    
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
  autostart = true
  
  cloudinit = libvirt_cloudinit_disk.commoninit.id

}