## Nested Inputs Reference
### notifications
- `name` - The name of the destination. When type is `SLACK`, it is channel name.
- `type` - The type of the destination. Allowed value is `EMAIL`, `PAGERDUTY_SERVICE_INTEGRATION`, `SLACK`.
- `destination_properties` - Specifies the properties of the destination. This input is required when the type is `EMAIL`.
  - `key` - Allowed value is `email`.
  - `value` - Specifies the email address to alert notification. If specifies multiple email addresses, connect them with `,`.
- `destination_auth_tokens` - Specifies the auth tokens of the destination. This input is required when the type is `PAGERDUTY_SERVICE_INTEGRATION`.
  - `prefix` - Allowed value is `Token token=`.
  - `token` - Specifies the token for integration.
- `destination_id` - Specifies the destination ID. This input is required when the type is `SLACK`. When the type is `SLACK` the destination is Slack workspace, and it is necessary to register the destination through the console. Refer to [New Relic Official Documentation](https://docs.newrelic.com/jp/docs/alerts-applied-intelligence/notifications/notification-integrations/#slack) for the registration procedure. After registering the destination, copy the destination ID from the destination list screen and specify it here.
- `channel_properties` - Specifies the properties of the channel. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/notification_channel#nested-property-blocks for details.
- `notification_triggers` - Issue events to notify on. The value is a list of possible issue events. See https://registry.terraform.io/providers/newrelic/newrelic/latest/docs/resources/workflow#notification-triggers for details.

## Usage
### 1. Configure NewRelic Provider
#### Example
##### provider.tf
```hcl
provider "newrelic" {
  account_id = "1234567"
  api_key    = "NRAK-XXXXXXXXXXXXXXXXXXXXXXXXX"
}
```
##### version.tf
```hcl
terraform {
  required_version = ">= 1.7.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">= 3.28.1"
    }
  }
}
```

### 2. Write Alert Condition parameters in "nrql_alert_conditions.csv"
#### Example
##### nrql_alert_conditions.csv
```csv
"name","nrql","type","operator","threshold","threshold_duration","threshold_occurrences","expiration_duration","close_violations_on_expiration","open_violation_on_expiration","aggregation_window","aggregation_method","aggregation_delay","aggregation_timer","fill_option","description","violation_time_limit_seconds","enabled"
"ECS Services CPU Utilization","SELECT average(`aws.ecs.CPUUtilization.byService`) FROM Metric FACET aws.ecs.ClusterName, aws.ecs.ServiceName","static","above_or_equals","90","300","ALL","false","false","false","60","EVENT_TIMER","120","60","None",,"2592000","true"
```
#### Note
For editing the CSV, it is recommended to use the CSV editing plugin of the IDE. If you are using VSCode, consider using something like [Edit csv](https://marketplace.visualstudio.com/items?itemName=janisdd.vscode-edit-csv).

### 3. Deploy module with refer to example usage