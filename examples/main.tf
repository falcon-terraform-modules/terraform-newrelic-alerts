module "alerts" {
  source = "falcon-terraform-modules/alerts/newrelic"

  newrelic_account_id              = "1234567"
  alert_policy_name                = "Example Production"
  alert_policy_incident_preference = "PER_CONDITION_AND_TARGET"
  nrql_alert_conditions            = csvdecode(file("nrql_alert_conditions.csv"))
  workflow_name                    = "Example Production"
  workflow_muting_rules_handling   = "DONT_NOTIFY_FULLY_MUTED_ISSUES"
  notifications = [
    {
      name = "Example Production Alerts Email"
      type = "EMAIL"
      destination_properties = [
        {
          key   = "email"
          value = "user@example.co.jp"
        }
      ]
      channel_properties = [
        {
          key   = "subjectd"
          value = "{{ issueTitle }}"
        }
      ]
      notification_triggers = [
        "ACTIVATED",
        "CLOSED"
      ]
    },
    {
      name           = "notify-example-production-alerts"
      type           = "SLACK"
      destination_id = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
      channel_properties = [
        {
          key   = "channelId"
          value = "CXXXXXXXXX"
        }
      ]
      notification_triggers = [
        "ACTIVATED",
        "CLOSED"
      ]
    },
    {
      name = "Example Service"
      type = "PAGERDUTY_SERVICE_INTEGRATION"
      destination_auth_tokens = [
        {
          prefix = "Token token="
          token  = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
        }
      ]
      channel_properties = [
        {
          key   = "summary"
          value = "{{ annotations.title.[0] }}"
        },
        {
          key   = "customDetails"
          value = <<-EOT
            {
            "id":{{json issueId}},
            "IssueURL":{{json issuePageUrl}},
            "NewRelic priority":{{json priority}},
            "Total Incidents":{{json totalIncidents}},
            "Impacted Entities":"{{#each entitiesData.names}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}",
            "Runbook":"{{#each accumulations.runbookUrl}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}",
            "Description":"{{#each annotations.description}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}",
            "isCorrelated":{{json isCorrelated}},
            "Alert Policy Names":"{{#each accumulations.policyName}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}",
            "alert_condition_names":"{{#each accumulations.conditionName}}{{this}}{{#unless @last}}, {{/unless}}{{/each}}",
            "Workflow Name":{{json workflowName}},
            }
          EOT
        }
      ]
      notification_triggers = [
        "ACTIVATED",
        "CLOSED"
      ]
    }
  ]
}