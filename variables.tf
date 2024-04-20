variable "newrelic_account_id" {
  description = "Specifies the New Relic account where the alerts setting will be created."
  type        = string
}

variable "alert_policy_name" {
  description = "The name of the policy to group alert conditions."
  type        = string
}

variable "alert_policy_incident_preference" {
  description = "The rollup strategy for the policy, which can have one of the following values (the default value is `PER_POLICY`). See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy#incident_preference for details."
  type        = string
  default     = "PER_POLICY"
}

variable "workflow_name" {
  description = "The name of the workflow."
  type        = string
}

variable "workflow_muting_rules_handling" {
  description = "Specifies how to handle muted issues. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow#muting-rules for details."
  type        = string
}

variable "notifications" {
  description = "Specifies the parameters necessary to configure alert notification destinations. See `Nested Inputs Reference` for details."
  type = list(object({
    name = string
    type = string
    destination_properties = optional(list(object({
      key   = string
      value = string
    })))
    destination_id = optional(string)
    channel_properties = list(object({
      key   = string
      value = string
    }))
    destination_auth_tokens = optional(list(object({
      prefix = string
      token  = string
    })))
    notification_triggers = list(string)
  }))
}

variable "nrql_alert_conditions" {
  description = "The name of the CSV file defined alert condition settings. Specify the name of CSV file using csvdecode function and file function (for example, csvdecode(file(\"nrql_alert_conditions.csv\")))."
  type        = any
}