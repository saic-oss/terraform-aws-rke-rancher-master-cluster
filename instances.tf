resource "aws_instance" "node_group_1" {
  count                       = local.node_group_1_count
  ami                         = local.node_group_1_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh.id
  user_data                   = local.instance_user_data
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  subnet_id                   = var.node_group_1_subnet_id
  associate_public_ip_address = true #tfsec:ignore:AWS012
  ebs_optimized               = true
  root_block_device {
    volume_type = "gp2"
    volume_size = var.node_volume_size
  }
  tags = merge(module.label.tags,
    {
      "Name" = "${module.label.id}-1.${count.index}"
  })
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      user        = local.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
    }
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ]
  }
}

resource "aws_instance" "node_group_2" {
  count                       = local.node_group_2_count
  ami                         = local.node_group_2_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh.id
  user_data                   = local.instance_user_data
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  subnet_id                   = var.node_group_2_subnet_id
  associate_public_ip_address = true #tfsec:ignore:AWS012
  ebs_optimized               = true
  root_block_device {
    volume_type = "gp2"
    volume_size = var.node_volume_size
  }
  tags = merge(module.label.tags,
    {
      "Name" = "${module.label.id}-2.${count.index}"
  })
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      user        = local.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
    }
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ]
  }
}

resource "aws_instance" "node_group_3" {
  count                       = local.node_group_3_count
  ami                         = local.node_group_3_ami
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.ssh.id
  user_data                   = local.instance_user_data
  vpc_security_group_ids      = [aws_security_group.nodes.id]
  subnet_id                   = var.node_group_3_subnet_id
  associate_public_ip_address = true #tfsec:ignore:AWS012
  ebs_optimized               = true
  root_block_device {
    volume_type = "gp2"
    volume_size = var.node_volume_size
  }
  tags = merge(module.label.tags,
    {
      "Name" = "${module.label.id}-3.${count.index}"
  })
  provisioner "remote-exec" {
    connection {
      host        = self.public_ip
      user        = local.ssh_user
      private_key = tls_private_key.ssh.private_key_pem
    }
    inline = [
      "echo 'Waiting for cloud-init to complete...'",
      "cloud-init status --wait > /dev/null",
      "echo 'Completed cloud-init!'"
    ]
  }
}
