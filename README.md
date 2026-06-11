<!-- BEGIN_TF_DOCS -->
# New Relic Alerts Terraform module
This Terraform module constructs and configures the necessary resources for NewRelic alert settings, including Alert Conditions, Alert Policies, Destinations, and Workflows.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_newrelic"></a> [newrelic](#requirement\_newrelic) | >= 3.91.0 |

## Resources

| Name | Type |
|------|------|
| [newrelic_alert_policy.main](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy) | resource |
| [newrelic_notification_channel.this](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_channel) | resource |
| [newrelic_notification_destination.this](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_destination) | resource |
| [newrelic_nrql_alert_condition.this](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/nrql_alert_condition) | resource |
| [newrelic_workflow.main](https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_newrelic_account_id"></a> [newrelic\_account\_id](#input\_newrelic\_account\_id) | Specifies the New Relic account where the alerts setting will be created. | `string` | n/a | yes |
| <a name="input_alert_policy_name"></a> [alert\_policy\_name](#input\_alert\_policy\_name) | The name of the policy to group alert conditions. | `string` | n/a | yes |
| <a name="input_alert_policy_incident_preference"></a> [alert\_policy\_incident\_preference](#input\_alert\_policy\_incident\_preference) | The rollup strategy for the policy, which can have one of the following values (the default value is `PER_POLICY`). See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/alert_policy#incident_preference for details. | `string` | `"PER_POLICY"` | no |
| <a name="input_workflow_name"></a> [workflow\_name](#input\_workflow\_name) | The name of the workflow. | `string` | n/a | yes |
| <a name="input_workflow_muting_rules_handling"></a> [workflow\_muting\_rules\_handling](#input\_workflow\_muting\_rules\_handling) | Specifies how to handle muted issues. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow#muting-rules for details. | `string` | n/a | yes |
| <a name="input_workflow_enabled"></a> [workflow\_enabled](#input\_workflow\_enabled) | Whether the workflow is enabled. | `bool` | `true` | no |
| <a name="input_notifications"></a> [notifications](#input\_notifications) | Specifies the parameters necessary to configure alert notification destinations. See `Nested Inputs Reference` for details. | <pre>list(object({<br/>    name = string<br/>    type = string<br/>    destination_properties = optional(list(object({<br/>      key   = string<br/>      value = string<br/>    })))<br/>    destination_auth_basic = optional(object({<br/>      user     = string<br/>      password = string<br/>    }))<br/>    destination_auth_custom_header = optional(object({<br/>      key   = string<br/>      value = string<br/>    }))<br/>    destination_secure_url = optional(object({<br/>      prefix        = string<br/>      secure_suffix = string<br/>    }))<br/>    destination_id = optional(string)<br/>    channel_properties = list(object({<br/>      key   = string<br/>      value = string<br/>    }))<br/>    destination_auth_tokens = optional(list(object({<br/>      prefix = string<br/>      token  = string<br/>    })))<br/>    notification_triggers = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_nrql_alert_conditions"></a> [nrql\_alert\_conditions](#input\_nrql\_alert\_conditions) | The name of the CSV file defined alert condition settings. Specify the name of CSV file using csvdecode function and file function (for example, csvdecode(file("nrql\_alert\_conditions.csv"))). | `any` | n/a | yes |

## Outputs

No outputs.

## Nested Inputs Reference
### notifications
- `name` - The name of the notification channel. For some types (for example, `SLACK`), this is the channel name.
- `type` - The type of the destination. This value is passed through to New Relic as-is. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_destination#type and https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_channel#type for supported types and required properties.
- `destination_id` - Specifies a pre-registered destination ID. When specified, Terraform does not create a destination and uses this ID for the channel. Use this when the destination must be registered through the console (for example, `SLACK` or `SLACK_COLLABORATION`). Refer to [New Relic Official Documentation](https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/notifications/notification-integrations/#slack) for the registration procedure. After registering the destination, copy the destination ID from the destination list screen and specify it here.
- `destination_properties` - Specifies the properties of the destination. When omitted, an empty property block is used. This input is required when the type needs destination properties (for example, `email` for `EMAIL`, or `url` for `WEBHOOK`).
  - `key` - The property key required by the destination type (for example, `email` or `url`).
  - `value` - The property value required by the destination type.
- `destination_auth_basic` - Specifies basic authentication for the destination. Applied when specified.
  - `user` - Specifies the username for basic authentication.
  - `password` - Specifies the password for basic authentication.
- `destination_auth_custom_header` - Specifies a custom header for the destination authentication. Applied when specified.
  - `key` - Specifies the header name.
  - `value` - Specifies the header value.
- `destination_secure_url` - Specifies a secure URL for the destination. Use this instead of `destination_properties` when the URL contains a secret suffix. Applied when specified.
  - `prefix` - Specifies the public part of the webhook URL.
  - `secure_suffix` - Specifies the secret part of the webhook URL.
- `destination_auth_tokens` - Specifies the auth tokens of the destination. Applied when specified (for example, `Token token=` for `PAGERDUTY_SERVICE_INTEGRATION`).
  - `prefix` - Specifies the token prefix (for example, `Token token=`).
  - `token` - Specifies the token value.
- `channel_properties` - Specifies the properties of the channel. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_channel#nested-property-blocks for details.
- `notification_triggers` - Issue events to notify on. The value is a list of possible issue events. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow#notification-triggers for details.

## Usage
### 1. Configure NewRelic Provider
#### Example
##### providers.tf
```hcl
provider "newrelic" {
  account_id = "1234567"
  api_key    = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXX"
}
```
##### terraform.tf
```hcl
terraform {
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = "= 3.91.0"
    }
  }
}
```

### 2. Write Alert Condition parameters in "nrql\_alert\_conditions.csv"
#### Example
##### nrql\_alert\_conditions.csv
```csv
"name","nrql","type","operator","threshold","threshold_duration","threshold_occurrences","expiration_duration","close_violations_on_expiration","open_violation_on_expiration","aggregation_window","aggregation_method","aggregation_delay","aggregation_timer","fill_option","description","violation_time_limit_seconds","enabled"
"ECS Services CPU Utilization","SELECT average(`aws.ecs.CPUUtilization.byService`) FROM Metric FACET aws.ecs.ClusterName, aws.ecs.ServiceName","static","above_or_equals","90","300","ALL","false","false","false","60","EVENT_TIMER","120","60","None",,"2592000","true"
```
#### Note
For editing the CSV, it is recommended to use the CSV editing plugin of the IDE. If you are using VSCode, consider using something like [Edit csv](https://marketplace.visualstudio.com/items?itemName=janisdd.vscode-edit-csv).

### 3. Deploy module with refer to example usage

## Example Usage
```hcl
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
```
<!-- END_TF_DOCS -->