variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

source "qemu" "debian" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  vm_name           = "debian.qcow2"
  disk_size         = "5G"
  format            = "qcow2"
  memory            = 1000
  http_directory    = "./"
  ssh_username      = "root"
  ssh_password      = "P@ssw0rd"
  ssh_timeout       = "20m"
  disk_interface    = "virtio"
  net_device        = "virtio-net"
  qemuargs          = [
    ["-m", "1024"],
    ["-smp", "4"],
  ]
  shutdown_command  = "echo 'packer' | sudo -S shutdown -P now"
  boot_wait         = "10s"
  boot_command      = [
    "<esc><wait>",
    "auto ",
    "net.ifnames=0 ",
    "preseed/url=http://{{.HTTPIP}}:{{.HTTPPort}}/preseed.cfg ",
    "<enter>"
  ]
}

build {
  sources = ["source.qemu.debian"]

  provisioner "shell" {
    scripts = [
      "./zabbix.sh"
    ]
  }
}
