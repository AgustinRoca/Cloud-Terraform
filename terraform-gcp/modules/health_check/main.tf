# La idea de este modulo es proveer un health check sencillo.
# Por esto creemos que las configuraciones internas hardcodeadas tienen sentido. 
# Los valores usados son bastante estandar.
# No cuenta dentro de los componentes distintos a implementar

resource "google_compute_health_check" "autohealing" {
  name                = var.health_check_name
  check_interval_sec  = 5
  timeout_sec         = 5
  healthy_threshold   = 2
  unhealthy_threshold = 10

  http_health_check {
    request_path = var.health_request_path
    port         = var.health_request_port
  }
}