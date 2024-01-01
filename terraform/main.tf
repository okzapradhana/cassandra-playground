terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {}

resource "docker_image" "cassandra" {
  name = var.image
}

resource "docker_network" "cassandra" {
  name = var.app_name
}

resource "docker_container" "cassandra" {
  image    = docker_image.cassandra.image_id
  name     = var.app_name
  hostname = var.app_name
  ports {
    internal = 9042
    external = 9042
  }
  networks_advanced {
    name = docker_network.cassandra.name
  }
}

resource "docker_image" "cassandra_web" {
  name = "delermando/docker-cassandra-web:v0.4.0"
}

resource "docker_container" "cassandra_web" {
  name = "cassandra_web"
  image = docker_image.cassandra_web.image_id
  ports {
    internal = 3000
    external = 3000
  }
  networks_advanced {
    name = docker_network.cassandra.name
  }
  depends_on = [ docker_container.cassandra ]
  env = [ "CASSANDRA_HOST_IP=${docker_container.cassandra.network_data[0].ip_address}", "CASSANDRA_PORT=9042" ]
}

# Using datastax studio
# resource "docker_image" "datastax_studio" {
#   name = "datastax/dse-studio:6.8.32"
# }

# resource "docker_container" "datastax_studio" {
#   image    = docker_image.datastax_studio.image_id
#   name     = "datastax_studio"
#   hostname = "datastax_studio"
#   networks_advanced {
#     name = docker_network.cassandra.name
#   }
#   ports {
#     internal = 9091
#     external = 9091
#   }
#   env = [ "DS_LICENSE=accept" ]
# }

# Try Netflix Data Explorer docker-compose-demo.yml