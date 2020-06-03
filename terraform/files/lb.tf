resource "google_compute_global_forwarding_rule" "reddit-frwd-rule" {
  name       = "reddit-frwd-rule"
  target     = google_compute_target_http_proxy.reddit-proxy.self_link
  port_range = "80"
}

resource "google_compute_target_http_proxy" "reddit-proxy" {
  name    = "reddit-proxy"
  url_map = google_compute_url_map.reddit-url-map.self_link
}

resource "google_compute_url_map" "reddit-url-map" {
  name            = "reddit-url-map"
  default_service = google_compute_backend_service.reddit-service.self_link
}

resource "google_compute_backend_service" "reddit-service" {
  health_checks = [
    google_compute_http_health_check.reddit-hc.self_link
  ]
  name      = "reddit-service"
  port_name = "http"
  protocol  = "HTTP"

  backend {
    group = google_compute_instance_group.reddit-group.self_link
  }
}

resource "google_compute_http_health_check" "reddit-hc" {
  name = "reddit-hc"
  port = 9292
}

resource "google_compute_instance_group" "reddit-group" {
  name      = "reddit-app-ugroup"
  zone      = var.zone
  instances = google_compute_instance.app.*.self_link

  named_port {
    name = "http"
    port = 9292
  }
}
