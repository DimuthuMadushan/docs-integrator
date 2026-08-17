---
connector: true
connector_name: "oraclefusion.common.scheduler"
title: "Oracle Fusion Common Scheduler Overview"
description: "Overview of the ballerinax/oraclefusion.common.scheduler connector for WSO2 Integrator."
---

# Oracle Fusion Common Scheduler

The Oracle Fusion Common Scheduler connector integrates with the Oracle Fusion Cloud Enterprise Scheduler Service (ESS) REST API, introduced in Oracle Fusion release 23B. It enables WSO2 Integrator to submit long-running background jobs — such as data imports, financial reports, and period-close processes — against Oracle-defined job definitions, and to track their execution through the full lifecycle. The connector supports both HTTP Basic and OAuth 2.0 client credentials authentication to match your Fusion instance's security configuration.

## Key Features

- Submit scheduled processes against a job definition, with job-specific request parameters, priority, retry count, timeout, and log level
- Query job requests using SCIM-style filters (for example, `state eq "RUNNING"`), with response field shaping and result ordering
- Retrieve the full execution detail of a specific job request, including its lifecycle state, state description, timestamps, and elapsed time
- Schedule recurring runs inline using iCal recurrence rules, timezone, and date exclusions or inclusions, or reference an existing schedule by ID
- Register callback subscriptions so the scheduler notifies your endpoint as a request changes state, as an alternative to polling
- Flexible authentication: HTTP Basic with Fusion integration user credentials, or OAuth 2.0 client credentials against Oracle Identity Cloud Service (IDCS)
- GraalVM compatible for native image builds

## Actions

The connector exposes a single client that covers all scheduler operations — submitting job requests, querying collections, and retrieving individual request detail.

| Client | Actions |
|--------|---------|
| `Client` | Submit job requests, query job requests with filters, retrieve job request detail by ID |

See the **[Action Reference](action-reference.md)** for the full list of operations, parameters, and sample code for each client.

## Documentation

* **[Setup Guide](setup-guide.md)**: How to identify your Fusion instance URL, provision an integration user, locate the target job definition, and configure authentication.

* **[Action Reference](action-reference.md)**: Full reference for all clients — operations, parameters, return types, and sample code.

* **[Example](example.md)**: Learn how to build and configure an integration using the **Oracle Fusion Common Scheduler** connector, including connection setup, operation configuration, and execution flow.

## How to contribute

As an open source project, WSO2 welcomes contributions from the community.

To contribute to the code for this connector, please create a pull request in the following repository.

* [Oracle Fusion Common Scheduler Connector GitHub repository](https://github.com/ballerina-platform/module-ballerinax-oraclefusion.common.scheduler)

Check the issue tracker for open issues that interest you. We look forward to receiving your contributions.