terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

resource "docker_image" "img-rabbit-discoverer" {
    name = "shekeriev/rabbit-discoverer"
}

resource "docker_image" "img-rabbit-observer" {
    name = "shekeriev/rabbit-observer"
}

resource "docker_container" "rabbit-discoverer" {
  name = "rabbit-discoverer"
  image = docker_image.img-rabbit-discoverer.image_id
  env = ["BROKER=rabbitmq", "TOPIC=animal-facts", "METRICPORT=5000"]

 ports {
        internal = 5000
        external = 8888
    }

  networks_advanced {
    name = "appnet"
  
  }
}

resource "docker_container" "rabbit-observer" {
  name = "rabbit-observer"
  image = docker_image.img-rabbit-observer.image_id
  env = ["BROKER=rabbitmq", "TOPIC=animal-facts", "APPPORT=80"]

   ports {
        internal = 80
        external = 8080
    }
    
  networks_advanced {
    name = "appnet"
  }
}
