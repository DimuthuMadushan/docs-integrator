---
connector: true
connector_name: "oraclefusion.common.scheduler"
title: "Oracle Fusion Common Scheduler Setup Guide"
description: "How to set up and configure the ballerinax/oraclefusion.common.scheduler connector."
---

# Setup Guide

This guide covers the service-side configuration steps required to connect to Oracle Fusion Cloud's Enterprise Scheduler Service (ESS) REST API.

## Prerequisites

- An active Oracle Fusion Cloud Applications instance running release 23B or later
- Security administration access to the Oracle Fusion Cloud instance
- For OAuth 2.0 authentication: access to the Oracle Identity Cloud Service (IDCS) tenant associated with your Fusion instance

## Identify your Fusion instance base URL

The Scheduler REST API base URL is instance-specific and follows this pattern:

```text
https://{fusionHost}/ess/rest/scheduler/v1
```

For example: `https://acme.fa.us2.oraclecloud.com/ess/rest/scheduler/v1`

Contact your Fusion system administrator or check your instance provisioning details to confirm the host name.

:::note
The generic Scheduler REST API is available from Oracle Fusion release 23B onwards. On earlier releases, use the product-specific ESS endpoints instead.
:::

## Provision a user with the required privileges

1. Sign in to your Oracle Fusion Cloud instance as a user with security administration rights.
2. Create or identify the integration user that will submit and monitor the scheduled processes.
3. Grant the roles required for the scheduled processes you intend to run. Submitting a process requires the privileges of the specific job definition; monitoring requires the privileges to view scheduled processes.
4. Consult your Fusion security administrator for the exact roles required for your module.

## Identify the job definition to submit

Submitting a request requires a `jobDefinitionId` — the metadata object ID of the process, not its display name. It takes a form such as:

```text
oracle/apps/ess/financials/payables/invoices/transactions/ImportPayablesInvoicesJob
```

Find it in the Fusion UI under **Tools > Scheduled Processes**, or ask your functional administrator. Each job definition also declares its own set of `requestParameters` (names, types, and order), so confirm those with your functional administrator before submitting.

## Choose and configure an authentication scheme

The Scheduler REST API supports two authentication schemes. Confirm with your Fusion administrator which scheme is enabled on your instance, as some pods disable HTTP Basic authentication for integration users.

**HTTP Basic authentication** uses the integration user's Fusion username and password over HTTPS. No additional service-side configuration is required beyond provisioning the user in the step above.

**OAuth 2.0 client credentials** requires registering a confidential application in Oracle Identity Cloud Service (IDCS):

1. Sign in to your IDCS console.
2. Navigate to **Applications** and create a new **Confidential Application**.
3. In the application's **Client** configuration, enable **Client Credentials** as an allowed grant type.
4. Under **Resources**, grant the application access to the Oracle Fusion Scheduler REST API resource. Work with your IDCS administrator to identify the correct scope or resource server for your Fusion tenant.
5. Activate the application and note the **Client ID** and **Client Secret** that IDCS generates.
6. Note your IDCS **token endpoint URL**, which takes the form: `https://<your-idcs-host>.identity.oraclecloud.com/oauth2/v1/token`.

:::note
The client ID, client secret, and token URL from IDCS are what you supply to the connector's `auth` configuration at connection time.
:::

## Next steps

- [Action Reference](action-reference.md) - Available operations