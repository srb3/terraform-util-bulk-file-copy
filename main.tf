locals {
  sum           = md5(jsonencode(fileset(var.local_path,var.file_pattern)))
  files         = fileset(var.local_path,var.file_pattern)
  tmp_path      = "${var.tmp_path}/${var.working_path}"
  file_tmp_path = "${local.tmp_path}/files"

  command = var.script != "" ? var.script : templatefile("${path.module}/templates/command.sh",{
    tmp_path         = local.tmp_path
    file_tmp_path    = local.file_tmp_path
    file_pattern     = var.file_pattern
    destination_path = var.remote_privileged_path
  })
}

resource "null_resource" "bulk_file_upload" {

  count = length(local.files) > 0 ? 1 : 0

  triggers = {
    data = local.sum
  }

  connection {
    type        = "ssh"
    user        = var.user_name
    private_key = file(var.ssh_user_private_key)
    host        = var.ip
  }

  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${local.file_tmp_path}"
    ]
  }

  provisioner "file" {
    source      = "${var.local_path}/"
    destination = local.file_tmp_path
  }

  provisioner "file" {
    content     = local.command
    destination = "${local.tmp_path}/command.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "bash ${local.tmp_path}/command.sh",
    ]
  }

}
