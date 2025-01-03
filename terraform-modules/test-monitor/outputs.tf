output "elasticsearch_username" {
  value = module.test_monitor.elasticsearch_username
}

output "elasticsearch_password" {
  value     = module.test_monitor.elasticsearch_password
  sensitive = true
}
