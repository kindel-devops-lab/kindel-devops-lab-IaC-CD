output "debug_target_image" {
    description = "Used docker image and tag"
    value = "sonelo77/devops-flask-api:${var.image_tag}"

}

output "web_app_url" {
  description = "APP public URL"
  value       = "http://${azurerm_container_group.aci.fqdn}"
}

output "web_app_health_url" {
  description = "Ready-to-use full URL for CD smoke test"
  value = "http://${azurerm_container_group.aci.fqdn}:${var.port}/health"
}

output "acr_login_server" {
  value = data.azurerm_container_registry.acr.login_server
}

output "port" {
  value = var.port
}