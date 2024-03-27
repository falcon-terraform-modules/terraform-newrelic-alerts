resource "newrelic_alert_policy" "main" {
  name                = var.alert_policy_name
  incident_preference = "PER_CONDITION_AND_TARGET"
}

resource "newrelic_nrql_alert_condition" "this" {
  for_each  = { for i in var.nrql_alert_conditions : i.name => i }
  policy_id = newrelic_alert_policy.main.id
  # Condition name
  name = each.value.name
  # Define your signal
  nrql {
    query = each.value.nrql
  }
  # Condition thresholds
  type = each.value.type
  critical {
    operator              = each.value.operator
    threshold             = each.value.threshold
    threshold_duration    = each.value.threshold_duration
    threshold_occurrences = each.value.threshold_occurrences
  }
  expiration_duration            = each.value.expiration_duration == "false" ? null : each.value.expiration_duration
  close_violations_on_expiration = each.value.close_violations_on_expiration
  open_violation_on_expiration   = each.value.open_violation_on_expiration
  # Advanced signal settings
  aggregation_window = each.value.aggregation_window
  aggregation_method = each.value.aggregation_method
  aggregation_delay  = each.value.aggregation_method == "EVENT_FLOW" ? each.value.aggregation_delay : null
  aggregation_timer  = each.value.aggregation_method == "EVENT_TIMER" ? each.value.aggregation_timer : null
  fill_option        = each.value.fill_option
  # Additional settings
  description                  = each.value.description
  violation_time_limit_seconds = each.value.violation_time_limit_seconds
  enabled                      = each.value.enabled
}

resource "newrelic_notification_destination" "this" {
  for_each   = { for i in var.notifications : i.name => i if i.type != "SLACK" }
  account_id = var.newrelic_account_id
  name       = each.value.name
  type       = each.value.type
  dynamic "property" {
    for_each = each.value.type == "PAGERDUTY_SERVICE_INTEGRATION" ? [{ key = "", value = "" }] : each.value.destination_properties
    content {
      key   = property.value.key
      value = property.value.value
    }
  }
  dynamic "auth_token" {
    for_each = each.value.type == "PAGERDUTY_SERVICE_INTEGRATION" ? each.value.destination_auth_tokens : []
    content {
      prefix = auth_token.value.prefix
      token  = auth_token.value.token
    }
  }
}

resource "newrelic_notification_channel" "this" {
  for_each       = { for i in var.notifications : i.name => i }
  name           = each.value.name
  type           = each.value.type
  destination_id = try(each.value.destination_id, newrelic_notification_destination.this[each.value.name].id)
  product        = "IINT"
  dynamic "property" {
    for_each = each.value.channel_properties
    content {
      key   = property.value.key
      value = property.value.value
    }
  }
}

resource "newrelic_workflow" "main" {
  name                  = var.workflow_name
  muting_rules_handling = var.workflow_muting_rules_handling
  issues_filter {
    name = "POLICY_FILTER"
    type = "FILTER"
    predicate {
      attribute = "labels.policyIds"
      operator  = "EXACTLY_MATCHES"
      values    = [newrelic_alert_policy.main.id]
    }
  }
  dynamic "destination" {
    for_each = var.notifications
    content {
      channel_id            = newrelic_notification_channel.this[destination.value.name].id
      notification_triggers = destination.value.notification_triggers
    }
  }
}