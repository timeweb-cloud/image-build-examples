variable "iso_url" {
  type = string
}

variable "iso_checksum" {
  type = string
}

variable "iso_virtio" {
  type = string
}

source "qemu" "windows_server" {
  iso_url           = var.iso_url
  iso_checksum      = var.iso_checksum
  vm_name           = "windows_server.qcow2"
  disk_size         = "40G"
  format            = "qcow2" # Format of the generated image
  disk_interface    = "virtio"
  memory            = 4000
  floppy_files = [
    "./Autounattend.xml",
    "./winrm.ps1",
  ]
  qemuargs          = [
    ["-smp", "6"],
    [ "-drive", "file=${var.iso_virtio},media=cdrom,index=3" ],
    [ "-drive", "file=output-windows_server/windows_server.qcow2,if=virtio,cache=writeback,discard=ignore,format=qcow2,index=1" ],
    [ "-drive", "file=${var.iso_url},media=cdrom" ] # Installer ISO
  ]
  shutdown_command  = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\" & cmd.exe /c net user packer /delete"
  boot_wait         = "10m"
  communicator      = "winrm"
  winrm_username    = "packer"
  winrm_password    = "packer"
  winrm_insecure    = true
  winrm_use_ssl     = true # uses port 5986 when true, otherwise 5985
  winrm_timeout     = "30m" # Set to high value as Windows install can take awhile to be ready
  pause_before_connecting = "1m30s"
}

build {
  sources = ["source.qemu.windows_server"]

  provisioner "windows-shell" {
    scripts = [
      "./enable-rdp.bat"
    ]
  }
}
