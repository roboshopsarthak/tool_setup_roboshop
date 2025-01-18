terraform {
    backend "s3" {
        bucket = "roboshop-terraform"
        key = "vault_secrets/terraform.tfstate"
        region = "us-east-1"
    }
}


variable "vault_token" {}

provider "vault" {
    address = "http://vault-internal.sarthak1207.shop:8200"
    token = var.vault_token
    skip_tls_verify = true
}



resource "vault_mount" "roboshop-dev" {
  path        = "roboshop-dev"
  type        = "kv"
  options     = { version = "2" }
  description = "RoboShop Dev Secrets"
}

resource "vault_generic_secret" "frontend" {
    path = "${vault_mount.roboshop-dev.path}/frontend" 
    data_json = <<EOT
{
    "catalogue_url": "http://catalogue-dev.sarthak1207.shop:8080/",
    "cart_url": "http://cart-dev.sarthak1207.shop:8080/",
    "payment_url": "http://payment-dev.sarthak1207.shop:8080/",
    "user_url": "http://user-dev.sarthak1207.shop:8080/",
    "shipping_url": "http://shipping-dev.sarthak1207.shop:8080/"
}
EOT
}

resource "vault_generic_secret" "catalogue" {
    path = "${vault_mount.roboshop-dev.path}/catalogue" 
    data_json = <<EOT
{
    "MONGO": "true",
    "MONGO_URL": "mongodb://mongodb-dev.sarthak1207.shop:27017/catalogue"

}
EOT
}

resource "vault_generic_secret" "user" {
    path = "${vault_mount.roboshop-dev.path}/user" 
    data_json = <<EOT
{
    "MONGO": "true",
    "REDIS_URL": "redis://redis-dev.sarthak1207.shop:6379",
    "MONGO_URL": "mongodb://mongodb-dev.sarthak1207.shop:27017/users"
}
EOT
}

resource "vault_generic_secret" "cart" {
    path = "${vault_mount.roboshop-dev.path}/cart" 
    data_json = <<EOT
{
    "REDIS_HOST": "redis-dev.sarthak1207.shop",
    "CATALOGUE_HOST": "catalogue-dev.sarthak1207.shop"
}
EOT
}

resource "vault_generic_secret" "payment" {
    path = "${vault_mount.roboshop-dev.path}/payment" 
    data_json = <<EOT
{
    "CART_HOST": "cart-dev.sarthak1207.shop",
    "CART_PORT": "8080",
    "USER_HOST": "user-dev.sarthak1207.shop",
    "USER_PORT": "8080",
    "AMQP_HOST": "rabbitmq-dev.sarthak1207.shop",
    "AMQP_USER": "roboshop",
    "AMQP_PASS": "roboshop123"
}
EOT
}

resource "vault_generic_secret" "shipping" {
    path = "${vault_mount.roboshop-dev.path}/shipping" 
    data_json = <<EOT
{
    "CART_ENDPOINT": "cart-dev.sarthak1207.shop:8080",
    "DB_HOST": "mysql-dev.sarthak1207.shop",
    "MYSQL_ROOT_PASSWORD": "RoboShop@1"
}
EOT
}

resource "vault_generic_secret" "mysql" {
    path = "${vault_mount.roboshop-dev.path}/mysql" 
    data_json = <<EOT
{
    "MYSQL_ROOT_PASSWORD": "RoboShop@1"
}
EOT
}

resource "vault_generic_secret" "rabbitmq" {
    path = "${vault_mount.roboshop-dev.path}/rabbitmq" 
    data_json = <<EOT
{
    "user": "roboshop",
    "password": "roboshop123"
}
EOT
}

resource "vault_mount" "infra-secrets" {
  path        = "infra-secrets"
  type        = "kv"
  options     = { version = "1" }
  description = "My infra Secrets"
}

resource "vault_generic_secret" "ssh" {
    path = "${vault_mount.infra-secrets.path}/ssh" 
    data_json = <<EOT
{
    "username": "ec2-user",
    "password": "DevOps321"
}
EOT
}

