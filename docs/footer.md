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