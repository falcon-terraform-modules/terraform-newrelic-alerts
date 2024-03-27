terraform {
  required_version = ">= 1.7.0"
  required_providers {
    newrelic = {
      source  = "newrelic/newrelic"
      version = ">= 3.28.1"
    }
  }
}