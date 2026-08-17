---
connector: true
connector_name: "oraclefusion.common.scheduler"
toc_max_heading_level: 4
title: "Oracle Fusion Common Scheduler Action Reference"
---

# Actions

The Oracle Fusion Common Scheduler connector exposes the following clients:

Available clients:

| Client | Purpose |
|--------|---------|
| [`Client`](#client) | Submit job requests, query job requests with filters, and retrieve job request detail by ID against the Oracle Fusion Enterprise Scheduler Service REST API |

---

## Client

The `Client` submits job requests to the Oracle Fusion Enterprise Scheduler Service (ESS), queries collections of job requests using SCIM-style filters, and retrieves the full execution detail of individual requests by ID.

### Configuration

#### ConnectionConfig

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `auth` | <code>http:OAuth2ClientCredentialsGrantConfig&#124;http:CredentialsConfig</code> | Required | Configurations related to client authentication |
| `httpVersion` | <code>http:HttpVersion</code> | <code>http:HTTP_2_0</code> | The HTTP version understood by the client |
| `http1Settings` | <code>ClientHttp1Settings</code> | — | Configurations related to HTTP/1.x protocol |
| `http2Settings` | <code>http:ClientHttp2Settings</code> | — | Configurations related to HTTP/2 protocol |
| `timeout` | <code>decimal</code> | <code>60</code> | The maximum time to wait (in seconds) for a response before closing the connection |
| `forwarded` | <code>string</code> | <code>"disable"</code> | The choice of setting `forwarded`/`x-forwarded` header |
| `poolConfig` | <code>http:PoolConfiguration</code> | — | Configurations associated with request pooling |
| `cache` | <code>http:CacheConfig</code> | — | HTTP caching related configurations |
| `compression` | <code>http:Compression</code> | <code>http:COMPRESSION_AUTO</code> | Specifies the way of handling compression (`accept-encoding`) header |
| `circuitBreaker` | <code>http:CircuitBreakerConfig</code> | — | Configurations associated with the behaviour of the Circuit Breaker |
| `retryConfig` | <code>http:RetryConfig</code> | — | Configurations associated with retrying |
| `responseLimits` | <code>http:ResponseLimitConfigs</code> | — | Configurations associated with inbound response size limits |
| `secureSocket` | <code>http:ClientSecureSocket</code> | — | SSL/TLS-related options |
| `proxy` | <code>http:ProxyConfig</code> | — | Proxy server related options |
| `validation` | <code>boolean</code> | <code>true</code> | Enables the inbound payload validation functionality provided by the constraint package |
| `laxDataBinding` | <code>boolean</code> | <code>true</code> | Enables relaxed data binding on the client side; `nil` values are treated as optional and absent fields are handled as `nilable` types |

### Initializing the client

```ballerina
import ballerinax/oraclefusion.common.scheduler;

scheduler:ConnectionConfig config = {
    auth: {
        username: "<fusion-integration-user>",
        password: "<password>"
    }
};
scheduler:Client client = check new (config, "https://<fusion-host>/fscmRestApi/resources/11.13.18.05/ess");
```

To use OAuth 2.0 client credentials instead of HTTP Basic:

```ballerina
scheduler:ConnectionConfig config = {
    auth: {
        tokenUrl: "https://<idcs-host>/oauth2/v1/token",
        clientId: "<client-id>",
        clientSecret: "<client-secret>"
    }
};
scheduler:Client client = check new (config, "https://<fusion-host>/fscmRestApi/resources/11.13.18.05/ess");
```

### Operations

#### Job Request Operations

<details>
<summary>submitJobRequest</summary>

<div>

Submits a new scheduled process (ESS) job request to Oracle Fusion. The request identifies the job definition to run, carries job-specific parameters, and optionally sets execution options such as priority, retry count, timeout, log level, start and end times, and an inline or referenced recurrence schedule. Returns the ID of the newly created request and hypermedia links to it and the actions currently available on it.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>SubmitRequestBody</code> | Yes | The job request to submit |
| `payload.jobDefinitionId` | <code>string</code> | Yes | Metadata object ID for the job definition or job set being submitted |
| `payload.application` | <code>string</code> | No | Application the job definition is deployed in; used with `product` to locate the definition |
| `payload.product` | <code>string</code> | No | Product the job definition belongs to; used with `application` to locate the definition |
| `payload.description` | <code>string</code> | No | Human-readable description of the request, echoed back by `getJobRequest` and `queryJobRequests` |
| `payload.requestParameters` | <code>RequestParameter[]</code> | No | Job-specific parameters passed through to the job definition |
| `payload.priority` | <code>int</code> | No | Request priority, 0–9; Oracle applies its own default (documented as 4) when omitted |
| `payload.retries` | <code>int</code> | No | Number of automatic retries on failure; Oracle applies its own default (documented as 0) when omitted |
| `payload.startTime` | <code>string</code> | No | When the request becomes eligible to run; omit to have the scheduler run it as soon as possible |
| `payload.endTime` | <code>string</code> | No | Point after which the request, or the remaining occurrences of its schedule, are no longer run |
| `payload.requestTimeout` | <code>int</code> | No | Maximum time the request is allowed to run before the scheduler times it out; a timed-out request reports `errorType` of `TIMEOUT` |
| `payload.requestLogLevel` | <code>string</code> | No | Verbosity the scheduler logs the request's execution at |
| `payload.requestCategory` | <code>string</code> | No | Caller-assigned category for the request, available as a `q` filter on `queryJobRequests` |
| `payload.schedule` | <code>ScheduleBase</code> | No | Inline schedule that makes the request recur; mutually exclusive with `scheduleId` |
| `payload.scheduleId` | <code>string</code> | No | Identifier of a schedule that already exists on the instance; mutually exclusive with `schedule` |
| `payload.executePast` | <code>boolean</code> | No | Whether schedule occurrences whose time has already passed are still executed |
| `payload.callbackSubscription` | <code>CallbackSubscriptionRequest</code> | No | Callback subscription notified as the request changes state, as an alternative to polling |
| `payload.requestExecutionContext` | <code>RequestExecutionContextIn</code> | No | Identifies the running request that is creating this one as a sub-request |
| `headers` | <code>map\<string&#124;string[]\></code> | No | Headers to be sent with the request |

**Returns:** `SubmitRequestResponse|error`

**Sample code:**

```ballerina
scheduler:SubmitRequestBody payload = {
    jobDefinitionId: "/oracle/apps/ess/financials/payables/invoices/tasks,ImportPayablesInvoices",
    application: "FinancialsEss",
    description: "Import Payables Invoices - submitted from Ballerina",
    priority: 4,
    requestParameters: [
        {name: "BusinessUnit", paramType: "STRING", value: "US1 Business Unit"},
        {name: "ImportSource", paramType: "STRING", value: "Spreadsheet"}
    ]
};
scheduler:SubmitRequestResponse result = check client->submitJobRequest(payload);
```

**Sample response:**

```json
{
  "id": 12345678,
  "links": [
    {
      "rel": "self",
      "href": "https://fusion.example.com/fscmRestApi/resources/11.13.18.05/ess/requests/12345678"
    },
    {
      "rel": "cancel",
      "href": "https://fusion.example.com/fscmRestApi/resources/11.13.18.05/ess/requests/12345678/cancel"
    }
  ]
}
```

</div>
</details>

<details>
<summary>queryJobRequests</summary>

<div>

Queries the collection of scheduled process (ESS) job requests on the Fusion instance. Supports SCIM-style filters to narrow by state, submitter, application, job definition, and many other fields; response field shaping via `fields` and `excludeFields`; and result ordering. Returns a page of matching `RequestDetails` records together with paging links.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map\<string&#124;string[]\></code> | No | Headers to be sent with the request |
| `queries.q` | <code>string</code> | No | SCIM-style filter expression, e.g. `state eq "RUNNING"`; queryable fields include `requestId`, `state`, `application`, `product`, `submitter`, `jobDefinitionId`, `priority`, `errorType`, `submissionTime`, and more |
| `queries.orderBy` | <code>string</code> | No | Sort expression in the form `fieldName[:asc\|desc]`, e.g. `submissionTime:desc` |
| `queries.id` | <code>string</code> | No | Comma-separated list of request IDs to return |
| `queries.fields` | <code>string</code> | No | Comma-separated list of fields to include in each response item |
| `queries.excludeFields` | <code>string</code> | No | Comma-separated list of fields to exclude from each response item |

**Returns:** `RequestQueryResponse|error`

**Sample code:**

```ballerina
scheduler:RequestQueryResponse result = check client->queryJobRequests(
    queries = {
        q: "state eq \"RUNNING\"",
        orderBy: "submissionTime:desc",
        fields: "requestId,description,state,submitter,elapsedTime"
    }
);
```

**Sample response:**

```json
{
  "pageIndex": 0,
  "count": 2,
  "items": [
    {
      "requestId": 12345678,
      "description": "Import Payables Invoices",
      "state": "RUNNING",
      "submitter": "FUSION_INTEG_USER",
      "elapsedTime": 45000
    },
    {
      "requestId": 12345679,
      "description": "Generate Financial Report",
      "state": "RUNNING",
      "submitter": "FUSION_INTEG_USER",
      "elapsedTime": 120000
    }
  ],
  "links": [
    {
      "rel": "self",
      "href": "https://fusion.example.com/fscmRestApi/resources/11.13.18.05/ess/requests?q=state+eq+%22RUNNING%22"
    }
  ]
}
```

</div>
</details>

<details>
<summary>getJobRequest</summary>

<div>

Retrieves the full execution detail of a single Enterprise Scheduler job request by its ID. Returns the request's current lifecycle state, state description, timestamps (submission, requested start, actual start, end, and completed), elapsed time, job definition, submitter, priority, parameters, schedule, error type, available actions, and hypermedia links. Use `fields` and `excludeFields` to shape the response, and `links` to filter the hypermedia link collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `requestId` | <code>int</code> | Yes | The ID of the job request to retrieve, as returned by `submitJobRequest` |
| `headers` | <code>map\<string&#124;string[]\></code> | No | Headers to be sent with the request |
| `queries.fields` | <code>string</code> | No | Comma-separated list of fields to return, e.g. `requestId,state,elapsedTime` |
| `queries.excludeFields` | <code>string</code> | No | Comma-separated list of fields to exclude from the response |
| `queries.links` | <code>string</code> | No | Comma-separated list of link relations to return, e.g. `cancel`; filters the `links` collection |

**Returns:** `RequestDetails|error`

**Sample code:**

```ballerina
scheduler:RequestDetails result = check client->getJobRequest(12345678);
```

**Sample response:**

```json
{
  "requestId": 12345678,
  "jobDefinitionId": "/oracle/apps/ess/financials/payables/invoices/tasks,ImportPayablesInvoices",
  "description": "Import Payables Invoices - submitted from Ballerina",
  "state": "SUCCEEDED",
  "stateDescription": "The process has completed successfully.",
  "requestType": "SINGLETON",
  "submitter": "FUSION_INTEG_USER",
  "application": "FinancialsEss",
  "priority": 4,
  "submissionTime": "2024-10-15T08:00:00.000Z",
  "requestedStartTime": "2024-10-15T08:00:00.000Z",
  "processStartTime": "2024-10-15T08:00:05.123Z",
  "processEndTime": "2024-10-15T08:02:33.456Z",
  "completedTime": "2024-10-15T08:02:35.789Z",
  "elapsedTime": 148333,
  "isCancellable": false,
  "isHoldable": false,
  "isForceCancelAllowed": false,
  "requestParameters": [
    {
      "name": "BusinessUnit",
      "paramType": "STRING",
      "value": "US1 Business Unit"
    },
    {
      "name": "ImportSource",
      "paramType": "STRING",
      "value": "Spreadsheet"
    }
  ],
  "links": [
    {
      "rel": "self",
      "href": "https://fusion.example.com/fscmRestApi/resources/11.13.18.05/ess/requests/12345678"
    }
  ]
}
```

</div>
</details>