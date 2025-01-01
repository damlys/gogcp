module "test_elastic" {
  source = "../../terraform-submodules/k8s-elastic"

  kibana_domain = "kibana.gogke-test-7.damlys.pl"
}

module "test_grafana" {
  source = "../../terraform-submodules/k8s-grafana"

  grafana_domain = "grafana.gogke-test-7.damlys.pl"
}
