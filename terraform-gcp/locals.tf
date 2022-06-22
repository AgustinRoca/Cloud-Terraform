locals {

  bucket = {
    objects = {
      index = {
        filename     = "index.html"
        content_type = "text/html"
      }
      error = {
        filename     = "error.html"
        content_type = "text/html"
      }
    }
  }

  # Archivos falsos de llave y certificado. Para poder hacer "terraform apply", habría que brindar verdaderos
  #  o comentar todo el código que hace mención a HTTPS
  ssl = {
    key = {
      filename = "private.key"
    }
    certificate = {
      filename = "certificate.crt"
    }
  }

  # A comparación con el TP2, solo usamos 1 subnet
  # La subnet que teníamos para el LB del bucket se eliminó, ya que ahora ese LB es de tipo "Global HTTPs"
  subnet = {
    for_cloud_sql = {
      name       = "cloud-stylegan-subnet-for-cloud-sql"
      cidr_range = "10.1.0.0/23"
    }
  }

  cloud_run = {
    services = {
      images_service = {
        name = "images-service"
        # Para este TP no se usó Container Registry
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
      gpu_service = {
        name = "gpu-service"
        # Para este TP no se usó Container Registry
        image = "us-docker.pkg.dev/cloudrun/container/hello"
      }
    }
  }
}