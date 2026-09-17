
variable "_hostname" {
    
    type = string
    description = ""

}

variable  "disk" {
   type = list(string)
   default = ["libvirt_volume.host0.id","libvirt_volume.host1.id","libvirt_volume.host2.id","libvirt_volume.host3.id"]
}

variable  "storage" {

    default = "/home/reis/storage"
}


variable  "imag_debian" {

    default = "https://cloud.debian.org/images/cloud/trixie/latest/debian-13-generic-amd64.qcow2"

}
