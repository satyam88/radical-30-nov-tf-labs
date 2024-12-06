provider "aws" {
  region = "ap-south-1"
}

resource "aws_instance" "web" {
  ami           = "ami-0912f71e06545ad88" # Amazon Linux 2 AMI ID
  instance_type = "t2.micro"
  key_name      = "terraform-demo"                # Replace with your SSH key name
  tags = {
    Name = "WebServer"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("C:/Users/Satyam/.ssh/terraform-demo.pem")
      host        = self.public_ip
    }
  }
}

output "web_server_public_ip" {
  value = aws_instance.web.public_ip
}
