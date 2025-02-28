provider "aws" {
  region = "us-east-1"
}

provider "vault" {
  address = "http://8200"
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id = "54cc1342-de84-05da-12e2-b84455631c3e"
      secret_id = "b5437dcc-0e6d-955f-b751-9c2c0b140ffe"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "mv" // change it according to your mount
  name  = "test-screct" // change it according to your secret
}
resource "aws_instance" "my_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"

  tags = {
    Name = "test"
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
