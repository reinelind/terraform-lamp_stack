resource "null_resource" "example_provisioner" {
  triggers = {
    public_ip = aws_instance.example_public.public_ip
  }

  connection {
    type  = "ssh"
    host  = aws_instance.example_public.public_ip
    user  = var.ssh_user
    port  = var.ssh_port
    agent = true
  }

  // copy our example script to the server
  provisioner "file" {
    source      = "files/get-public-ip.sh"
    destination = "/tmp/get-public-ip.sh"
  }

  // change permissions to executable and pipe its output into a new file
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/get-public-ip.sh",
      "/tmp/get-public-ip.sh > /tmp/public-ip",
    ]
  }

  provisioner "local-exec" {
    # copy the public-ip file back to CWD, which will be tested
    command = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null ${var.ssh_user}@${aws_instance.example_public.public_ip}:/tmp/public-ip public-ip"
  }
}