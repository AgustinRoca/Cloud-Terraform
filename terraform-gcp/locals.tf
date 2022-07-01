locals {
  app_name = "innocenceproject"
  domain   = "innocenceproject.com"
  env      = "dev"

  // Backend Services
  services = [
    {
      "service" : "image-service",
      "type" : "cloud_run",
      "path" : "/imageservice/*",
      "path_prefix_rewrite" : "/"
    },
    {
      "service" : "gpu-service",
      "type" : "cloud_run",
      "path" : "/gpuservice/*",
      "path_prefix_rewrite" : "/"
    }
  ]
}
