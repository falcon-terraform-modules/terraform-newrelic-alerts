variable "newrelic_account_id" {
  description = "Specifies the New Relic account where the alerts setting will be created."
  type        = string
}

variable "alert_policy_name" {
  description = "The name of the policy to group alert conditions."
  type        = string
}

variable "nrql_alert_conditions" {
  description = "The name of the CSV file defined alert condition settings. Specify the name of CSV file using csvdecode function and file function (for example, csvdecode(file(\"nrql_alert_conditions.csv\")))."
  type        = any
}

variable "notifications" {
  description = "Specifies the parameters necessary to configure alert notification destinations."
  type        = any
}

variable "workflow_name" {
  description = "The name of the workflow."
  type        = string
}

variable "workflow_muting_rules_handling" {
  description = "Specifies how to handle muted issues. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow#muting-rules for details."
  type        = string
}