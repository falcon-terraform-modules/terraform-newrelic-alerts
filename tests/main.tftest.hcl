variables {
  alert_policy_name                = "Example Production"
  alert_policy_incident_preference = "PER_CONDITION_AND_TARGET"
  nrql_alert_conditions            = csvdecode(file("./tests/nrql_alert_conditions.csv"))
  workflow_name                    = "Example Production"
  workflow_muting_rules_handling   = "DONT_NOTIFY_FULLY_MUTED_ISSUES"
}

provider "newrelic" {
  account_id = var.newrelic_account_id
  api_key    = var.api_key
}

run "main" {
  command = apply
}