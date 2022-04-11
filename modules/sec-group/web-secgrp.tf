
locals {
  rules = [
    {
      port = "8080"
    },

    {
      port = "22"
    }
  ]
}
resource "aws_security_group" "web-access" {
  name        = "web-access"
  description = "Gives web access to container"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = local.rules
    content {
      from_port        = ingress.value.port
      to_port          = ingress.value.port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

output "secGroupID" {
  value = aws_security_group.web-access.id
}