provider "aws" {
  region = "us-east-1"
  # Option 1: Set your AWS credentials here (not recommended for production)
  # access_key = "YOUR_AWS_ACCESS_KEY"
  # secret_key = "YOUR_AWS_SECRET_KEY"
  # Option 2: Export these variables in your shell:
  # export AWS_ACCESS_KEY_ID="YOUR_AWS_ACCESS_KEY"
  # export AWS_SECRET_ACCESS_KEY="YOUR_AWS_SECRET_KEY"
}

provider "vault" {
  address = "http://127.0.0.1:8200"  # Fixed Vault address
  skip_child_token = true

  auth_login {
    path = "auth/approle/login"

    parameters = {
      role_id   = "54cc1342-de84-05da-12e2-b84455631c3e"
      secret_id = "b5437dcc-0e6d-955f-b751-9c2c0b140ffe"
    }
  }
}

data "vault_kv_secret_v2" "example" {
  mount = "kv"       // Change this according to your KV mount path
  name  = "test-screct"  // Change this to the name of your secret
}

resource "aws_instance" "my_instance" {
  ami           = "ami-04b4f1a9cf54c11d0"
  instance_type = "t2.micro"

  tags = {
    Secret = data.vault_kv_secret_v2.example.data["username"]
  }
}
