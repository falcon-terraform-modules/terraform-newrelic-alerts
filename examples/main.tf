module "alerts" {
  source = "falcon-terraform-modules/alerts/newrelic"

  newrelic_account_id              = "1234567"
  alert_policy_name                = "Example Production"
  alert_policy_incident_preference = "PER_CONDITION_AND_TARGET"
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
      name = "Example Production Alerts Webhook"
      type = "WEBHOOK"
      destination_secure_url = {
        prefix = "https://example.com/webhook"
        secure_suffix = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      }
      destination_auth_custom_header = {
        key   = "Authorization"
        value = "Bearer xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
      }
      channel_properties = [
        {
          key   = "payload"
          value = <<-EOT
            {
              "id": {{ json issueId }},
              "issueUrl": {{ json issuePageUrl }},
              "title": {{ json annotations.title.[0] }},
              "priority": {{ json priority }},
              "impactedEntities": {{json entitiesData.names}},
              "state": {{ json state }},
              "trigger": {{ json triggerEvent }},
              "isCorrelated": {{ json isCorrelated }},
              "createdAt": {{ createdAt }},
              "updatedAt": {{ updatedAt }},
              "sources": {{ json accumulations.source }},
              "alertPolicyNames": {{ json accumulations.policyName }},
              "alertConditionNames": {{ json accumulations.conditionName }},
              "workflowName": {{ json workflowName }}
            }
          EOT
        }
      ]
      notification_triggers = [
        "ACTIVATED"
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
  nrql_alert_conditions = csvdecode(file("nrql_alert_conditions.csv"))
}