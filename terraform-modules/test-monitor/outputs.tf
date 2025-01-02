# output "elasticsearch_username" {
#   value = module.test_elk_stack.elasticsearch_username
# }

# output "elasticsearch_password" {
#   value     = module.test_elk_stack.elasticsearch_password
#   sensitive = true
# }

output "grafana_username" {
  value = module.test_lgtm_stack.grafana_username
}

output "grafana_password" {
  value     = module.test_lgtm_stack.grafana_password
  sensitive = true
}
