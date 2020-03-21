# This security group is exposing HTTPS to Cloudflare. 
# This is just an example, and is relying on Cloudflare's being a trustable 
# source as all the secrets will pass throug their endpoint! (but hey, no VPN!)
resource "aws_security_group" "cloudflare-http" {
  name_prefix = "cloudflare-http-"
  description = "Allow HTTP/s only to CloudFlare"

  ingress {
    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    # Source: https://www.cloudflare.com/ips/
    cidr_blocks = [
      "173.245.48.0/20",
      "103.21.244.0/22",
      "103.22.200.0/22",
      "103.31.4.0/22",
      "141.101.64.0/18",
      "108.162.192.0/18",
      "190.93.240.0/20",
      "188.114.96.0/20",
      "197.234.240.0/22",
      "198.41.128.0/17",
      "162.158.0.0/15",
      "104.16.0.0/12",
      "172.64.0.0/13",
      "131.0.72.0/22",
    ]

    # Source: https://www.cloudflare.com/ips/
    ipv6_cidr_blocks = [
      "2400:cb00::/32",
      "2606:4700::/32",
      "2803:f800::/32",
      "2405:b500::/32",
      "2405:8100::/32",
      "2a06:98c0::/29",
      "2c0f:f248::/32"
    ]
  }
}


resource "aws_security_group" "allow-exit" {
  name_prefix = "exit-allowed"
  description = "Allows all egress connections"

  # Allow all connection in exit
  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "udp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "ssh" {
  name_prefix = "ssh-"
  description = "Allow SSH access"

  ingress {
    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }
}
