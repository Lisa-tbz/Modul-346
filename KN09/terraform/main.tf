provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "db_sg" {
  name        = "db-kn09"
  description = "Security Group for Database"

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "db-kn09"
  }
}

resource "aws_instance" "db" {
  ami           = "ami-0ecb62995f68bb549"
  instance_type = "t2.micro"

  vpc_security_group_ids = [aws_security_group.db_sg.id]

  # Optional: wenn du ein Key-Pair über AWS benutzt
  # key_name = "mein-keypair"

  user_data = <<-EOF
    #cloud-config
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsTbOWQi+eeflo52Y2Kuie0xAzQUrXdjuSeG0cmEm4XGHX7GSqbDctfmfmpkDxB8vv9xL1Q0DzGfeKokUskUYEDPMZFGdaWdYoDAUCM7rGsLOtZv+gsvuN5u1/1OrjcvaXhK9xMDrrFyQAd3uOh0URQHjiwFne6WE/5blLcO5RhvAbqo1itdL+wm9gMtmjEEUiWtsxe+Hi34kDBGFTSt/ajwOv3sDTHzS+9EitBE9h0U8nYUdIQchwE4sg6Lg4jXmA3Ti3sGU7mzKpPQ9FJAounSf06FQ98xcMoqINNVfG13IR/ZJfnyyvjLGO9hYKY/quatr/feWkYC0G/2OZleXr aws-key-lis
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC0WGP1EZykEtv5YGC9nMiPFW3U3DmZNzKFO5nEu6uozEHh4jLZzPNHSrfFTuQ2GnRDSt+XbOtTLdcj2+iPNiFoFha42aCIzYjt6V8Z+SQ9pzF4jPPzxwXfDdkEWylgoNnZ4MG1lNFqa8aO7F62tX0Yj5khjC0Bs7Mb2cHLx1XZaxJV6qSaulDuBbLYe8QUZXkMc7wmob3PM0kflflR3LE7LResIHWa4j4FL6r5cQmFlDU2BDPpKMFMGUfRSFiUtaWBNXFOWHQBC2+uKmuMPYP4vJC9sBgqMvPN/X2KyemqdMvdKXnCfrzadHuSSJYEzD64Cve5Zl9yVvY4AqyBD aws-key-NUY
    packages:
      - mysql-server
    runcmd:
      - sed -i "s/bind-address.*/bind-address = 0.0.0.0/" /etc/mysql/mysql.conf.d/mysqld.cnf
      - systemctl enable mysql
      - systemctl restart mysql
  EOF

  tags = {
    Name = "db-kn09"
  }
}
