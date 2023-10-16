data "aws_ami" "server_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "image-id"
    values = ["ami-0c3472daea3f355b7"]
  }
  #   filter {
  #     name   = "name"
  #     values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  #   }
  # ami-0c3472daea3f355b7 # Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-07-28
}

resource "random_id" "node_id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

resource "aws_instance" "node" {
  count                = var.instance_count
  instance_type        = var.instance_type
  ami                  = data.aws_ami.server_ami.id
  iam_instance_profile = var.iam_instance_profile.name

  tags = {
    Name = "node-${random_id.node_id[count.index].dec}"
  }
  key_name               = aws_key_pair.auth.id
  vpc_security_group_ids = tolist([var.public_sg, var.private_sg])

  subnet_id = var.public_subnets[count.index]
  user_data = templatefile(var.user_data_path, {
    nodename    = "${var.project_id}-${terraform.workspace}--${random_id.node_id[count.index].dec}"
    msk_version = var.msk_version
  })
  root_block_device {
    volume_size = var.vol_size
  }
}