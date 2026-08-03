---
connector: true
connector_name: "pricefx"
title: "Setup Guide"
description: "How to set up and configure the ballerinax/pricefx connector."
---

# Setup Guide

This guide walks you through getting the details the connector needs to authenticate and communicate with your Pricefx partition.

## Choose an authentication method

The connector supports several ways to authenticate with Pricefx. Provide exactly one of the following credential combinations.

### Username, password, and partition

The most common setup. Sign in to your Pricefx partition to confirm your user name, password, and partition name.

:::tip
Contact Pricefx Support for an API key (`pricefxKey`) if you want the faster `POST /token` exchange. Without one, the connector falls back to HTTP Basic auth (`<partition>/<username>:<password>` on every request), which needs no separate key but is slower per request.
:::

### OAuth 2.0

Provide `oauth2ClientId`, `oauth2RefreshToken`, and optionally `oauth2ClientSecret`. The refresh token must be obtained once beforehand through Pricefx's Authorization Code Grant flow — that initial exchange needs an interactive browser redirect and can't be automated by this connector. Once you have a refresh token, the connector fetches and refreshes access tokens automatically.

### External JWT

Provide `externalJwtSystemName` and `externalJwt`, if your organization has a trust relationship configured on the Pricefx side (`externalJWTConfiguration`) with an external system that signs JWTs on your behalf.

## Optional settings

Independently of the authentication method you choose, you can also set:

- `tfaCode` — a two-factor authentication code, if your user has TFA enabled
- `csrfToken` — a CSRF token, if your partition has CSRF protection enabled

The connector automatically re-authenticates and retries once whenever a request comes back unauthenticated, so a long-lived client instance keeps working without manual re-initialization.

## Note your service URL

The connector connects to `https://<your-node>.pricefx.com/pricefx/<your-partition>` by default. Confirm your node and partition name with your Pricefx administrator if you're not sure.

## Next steps

- [Action Reference](action-reference.md) - Available operations
