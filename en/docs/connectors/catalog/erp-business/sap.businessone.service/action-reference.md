---
connector: true
connector_name: "sap.businessone.service"
toc_max_heading_level: 4
---

# Actions

The `ballerinax/sap.businessone.service` package exposes the following clients:

Available clients:

| Client | Purpose |
|--------|---------|
| [`Client`](#client) | Create, query, update, and process SAP Business One service module objects — service calls, contracts, contract templates, customer equipment cards, and the solutions knowledge base — over the session-authenticated Service Layer (OData V3). |

---

## Client

The `Client` provides access to every service module object exposed by the SAP Business One Service Layer — service calls, service contracts, contract templates, customer equipment cards, the knowledge base, queues, and service call reference data (origins, problem types & sub-types, statuses, and call types).

### Configuration

#### SessionConfig

SAP Business One Service Layer session credentials, passed as the first argument to the client initializer.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `companyDb` | <code>string</code> | Required | The SAP Business One company database to log in to |
| `username` | <code>string</code> | Required | The Service Layer user name |
| `password` | <code>string</code> | Required | The Service Layer user password |

#### ConnectionConfig

Provides a set of configurations for controlling the behaviours when communicating with the Service Layer HTTP endpoint. Passed as the optional second argument to the client initializer.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `httpVersion` | <code>http:HttpVersion</code> | <code>http:HTTP_2_0</code> | The HTTP version understood by the client |
| `http1Settings` | <code>http:ClientHttp1Settings</code> | <code>{}</code> | Configurations related to HTTP/1.x protocol |
| `http2Settings` | <code>http:ClientHttp2Settings</code> | <code>{}</code> | Configurations related to HTTP/2 protocol |
| `timeout` | <code>decimal</code> | <code>30</code> | The maximum time to wait (in seconds) for a response before closing the connection |
| `forwarded` | <code>string</code> | <code>"disable"</code> | The choice of setting `forwarded`/`x-forwarded` header |
| `followRedirects` | <code>http:FollowRedirects</code> | Optional | Configurations associated with redirection |
| `poolConfig` | <code>http:PoolConfiguration</code> | Optional | Configurations associated with request pooling |
| `cache` | <code>http:CacheConfig</code> | <code>{}</code> | HTTP caching related configurations |
| `compression` | <code>http:Compression</code> | <code>http:COMPRESSION_AUTO</code> | Specifies the way of handling compression (`accept-encoding`) header |
| `circuitBreaker` | <code>http:CircuitBreakerConfig</code> | Optional | Configurations associated with the behaviour of the Circuit Breaker |
| `retryConfig` | <code>http:RetryConfig</code> | Optional | Configurations associated with retrying |
| `cookieConfig` | <code>http:CookieConfig</code> | Optional | Configurations associated with cookies |
| `responseLimits` | <code>http:ResponseLimitConfigs</code> | <code>{}</code> | Configurations associated with inbound response size limits |
| `secureSocket` | <code>http:ClientSecureSocket</code> | Optional | SSL/TLS-related options |
| `proxy` | <code>http:ProxyConfig</code> | Optional | Proxy server related options |
| `socketConfig` | <code>http:ClientSocketConfig</code> | <code>{}</code> | Provides settings related to client socket configuration |
| `validation` | <code>boolean</code> | <code>true</code> | Enables the inbound payload validation functionality provided by the constraint package |
| `laxDataBinding` | <code>boolean</code> | <code>true</code> | Enables relaxed data binding on the client side, treating `nil` values and absent fields as optional |

The client also accepts a `serviceUrl` string parameter — the base URL of the target Service Layer instance — which defaults to `https://localhost:50000/b1s/v1`.

### Initializing the client

```ballerina
import ballerinax/sap.businessone;
import ballerinax/sap.businessone.service;

businessone:SessionConfig session = {
    companyDb: "SBODemoUS",
    username: "manager",
    password: "<password>"
};

service:Client client = check new (session, serviceUrl = "https://<host>:50000/b1s/v1");
```

### Operations

#### Service Calls

<details>
<summary>listServiceCalls</summary>

<div>

Query the ServiceCalls collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallsHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallsQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallsCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallsCollectionResponse response = check client->listServiceCalls(
    queries = {dollarFilter: "Status eq 1", dollarTop: 20, dollarOrderby: "ServiceCallID desc"}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCalls",
  "value": [
    {
      "ServiceCallID": 501,
      "Subject": "Printer not powering on",
      "CustomerCode": "C00001",
      "CustomerName": "ACME Corp",
      "ItemCode": "A00001",
      "Status": 1,
      "Priority": "scp_High",
      "CallType": 3,
      "ProblemType": 5,
      "Description": "Device does not power on after outage",
      "CreationDate": "2026-07-01",
      "Queue": "SUPPORT"
    }
  ],
  "odata.nextLink": "ServiceCalls?$skip=20"
}
```

</div>
</details>

<details>
<summary>createServiceCalls</summary>

<div>

Create a new ServiceCall.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCall</code> | Yes | The service call to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCall&#124;error`

**Sample code:**

```ballerina
ServiceCall created = check client->createServiceCalls({
    Subject: "Printer not powering on",
    CustomerCode: "C00001",
    ItemCode: "A00001",
    Priority: "scp_High",
    CallType: 3,
    ProblemType: 5,
    Description: "Device does not power on after outage"
});
```

**Sample response:**

```json
{
  "ServiceCallID": 501,
  "Subject": "Printer not powering on",
  "CustomerCode": "C00001",
  "ItemCode": "A00001",
  "Status": 1,
  "Priority": "scp_High",
  "CallType": 3,
  "ProblemType": 5,
  "Description": "Device does not power on after outage",
  "CreationDate": "2026-07-01"
}
```

</div>
</details>

<details>
<summary>getServiceCalls</summary>

<div>

Get a single ServiceCall by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `serviceCallID` | <code>int:Signed32</code> | Yes | Key property 'ServiceCallID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallsQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCall&#124;error`

**Sample code:**

```ballerina
ServiceCall call = check client->getServiceCalls(501);
```

**Sample response:**

```json
{
  "ServiceCallID": 501,
  "Subject": "Printer not powering on",
  "CustomerCode": "C00001",
  "CustomerName": "ACME Corp",
  "Status": 1,
  "Priority": "scp_High",
  "CallType": 3,
  "ProblemType": 5,
  "Description": "Device does not power on after outage",
  "CreationDate": "2026-07-01",
  "Queue": "SUPPORT"
}
```

</div>
</details>

<details>
<summary>deleteServiceCalls</summary>

<div>

Delete a ServiceCall.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `serviceCallID` | <code>int:Signed32</code> | Yes | Key property 'ServiceCallID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCalls(501);
```

</div>
</details>

<details>
<summary>updateServiceCalls</summary>

<div>

Partially update a ServiceCall (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `serviceCallID` | <code>int:Signed32</code> | Yes | Key property 'ServiceCallID' (Edm.Int32) |
| `payload` | <code>ServiceCall</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCalls(501, {Resolution: "Replaced power supply unit", Status: 2});
```

</div>
</details>

<details>
<summary>serviceCallsClose</summary>

<div>

Bound action 'Close' on ServiceCalls (binding type ServiceCall).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `serviceCallID` | <code>int:Signed32</code> | Yes | Key property 'ServiceCallID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->serviceCallsClose(501);
```

</div>
</details>

#### Service Contracts

<details>
<summary>listServiceContracts</summary>

<div>

Query the ServiceContracts collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceContractsHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceContractsQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceContractsCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceContractsCollectionResponse response = check client->listServiceContracts(
    queries = {dollarFilter: "Status eq 'scs_Approved'", dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceContracts",
  "value": [
    {
      "ContractID": 301,
      "CustomerCode": "C00001",
      "CustomerName": "ACME Corp",
      "Status": "scs_Approved",
      "ContractTemplate": "GOLD",
      "ContractType": "ct_Customer",
      "StartDate": "2026-01-01",
      "EndDate": "2026-12-31",
      "ResolutionTime": 4,
      "ResolutionUnit": "rsu_Hours",
      "Description": "Gold-tier annual support contract"
    }
  ]
}
```

</div>
</details>

<details>
<summary>createServiceContracts</summary>

<div>

Create a new ServiceContract.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceContract</code> | Yes | The service contract to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceContract&#124;error`

**Sample code:**

```ballerina
ServiceContract created = check client->createServiceContracts({
    CustomerCode: "C00001",
    ContractTemplate: "GOLD",
    ContractType: "ct_Customer",
    StartDate: "2026-01-01",
    EndDate: "2026-12-31",
    Description: "Gold-tier annual support contract"
});
```

**Sample response:**

```json
{
  "ContractID": 301,
  "CustomerCode": "C00001",
  "Status": "scs_Draft",
  "ContractTemplate": "GOLD",
  "ContractType": "ct_Customer",
  "StartDate": "2026-01-01",
  "EndDate": "2026-12-31",
  "Description": "Gold-tier annual support contract"
}
```

</div>
</details>

<details>
<summary>getServiceContracts</summary>

<div>

Get a single ServiceContract by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `contractID` | <code>int:Signed32</code> | Yes | Key property 'ContractID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceContractsQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceContract&#124;error`

**Sample code:**

```ballerina
ServiceContract contract = check client->getServiceContracts(301);
```

**Sample response:**

```json
{
  "ContractID": 301,
  "CustomerCode": "C00001",
  "CustomerName": "ACME Corp",
  "Status": "scs_Approved",
  "ContractTemplate": "GOLD",
  "ContractType": "ct_Customer",
  "StartDate": "2026-01-01",
  "EndDate": "2026-12-31",
  "Description": "Gold-tier annual support contract"
}
```

</div>
</details>

<details>
<summary>deleteServiceContracts</summary>

<div>

Delete a ServiceContract.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `contractID` | <code>int:Signed32</code> | Yes | Key property 'ContractID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceContracts(301);
```

</div>
</details>

<details>
<summary>updateServiceContracts</summary>

<div>

Partially update a ServiceContract (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `contractID` | <code>int:Signed32</code> | Yes | Key property 'ContractID' (Edm.Int32) |
| `payload` | <code>ServiceContract</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceContracts(301, {Description: "Gold-tier annual support contract — renewed"});
```

</div>
</details>

<details>
<summary>serviceContractsCancel</summary>

<div>

Bound action 'Cancel' on ServiceContracts (binding type ServiceContract).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `contractID` | <code>int:Signed32</code> | Yes | Key property 'ContractID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->serviceContractsCancel(301);
```

</div>
</details>

<details>
<summary>serviceContractsClose</summary>

<div>

Bound action 'Close' on ServiceContracts (binding type ServiceContract).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `contractID` | <code>int:Signed32</code> | Yes | Key property 'ContractID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->serviceContractsClose(301);
```

</div>
</details>

#### Contract Templates

<details>
<summary>listContractTemplates</summary>

<div>

Query the ContractTemplates collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListContractTemplatesHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListContractTemplatesQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ContractTemplatesCollectionResponse&#124;error`

**Sample code:**

```ballerina
ContractTemplatesCollectionResponse response = check client->listContractTemplates(queries = {dollarTop: 20});
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ContractTemplates",
  "value": [
    {
      "TemplateName": "GOLD",
      "TemplateIsRenewal": "tYES",
      "DurationOfCoverage": 12,
      "ResponseValue": 4,
      "ResolutionUnit": "rsu_Hours",
      "Description": "Gold-tier annual support contract template",
      "ContractType": "ct_Customer",
      "IncludeParts": "tYES",
      "IncludeLabor": "tYES",
      "IncludeTravel": "tNO"
    }
  ]
}
```

</div>
</details>

<details>
<summary>createContractTemplates</summary>

<div>

Create a new ContractTemplate.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ContractTemplate</code> | Yes | The contract template to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ContractTemplate&#124;error`

**Sample code:**

```ballerina
ContractTemplate created = check client->createContractTemplates({
    TemplateName: "GOLD",
    TemplateIsRenewal: "tYES",
    DurationOfCoverage: 12,
    ResponseValue: 4,
    ResolutionUnit: "rsu_Hours",
    ContractType: "ct_Customer",
    Description: "Gold-tier annual support contract template",
    IncludeParts: "tYES",
    IncludeLabor: "tYES",
    IncludeTravel: "tNO"
});
```

**Sample response:**

```json
{
  "TemplateName": "GOLD",
  "TemplateIsRenewal": "tYES",
  "DurationOfCoverage": 12,
  "ResponseValue": 4,
  "ResolutionUnit": "rsu_Hours",
  "ContractType": "ct_Customer",
  "Description": "Gold-tier annual support contract template"
}
```

</div>
</details>

<details>
<summary>getContractTemplates</summary>

<div>

Get a single ContractTemplate by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `templateName` | <code>string</code> | Yes | Key property 'TemplateName' (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetContractTemplatesQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ContractTemplate&#124;error`

**Sample code:**

```ballerina
ContractTemplate template = check client->getContractTemplates("GOLD");
```

**Sample response:**

```json
{
  "TemplateName": "GOLD",
  "TemplateIsRenewal": "tYES",
  "DurationOfCoverage": 12,
  "ResponseValue": 4,
  "ResolutionUnit": "rsu_Hours",
  "ContractType": "ct_Customer",
  "Description": "Gold-tier annual support contract template"
}
```

</div>
</details>

<details>
<summary>deleteContractTemplates</summary>

<div>

Delete a ContractTemplate.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `templateName` | <code>string</code> | Yes | Key property 'TemplateName' (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteContractTemplates("GOLD");
```

</div>
</details>

<details>
<summary>updateContractTemplates</summary>

<div>

Partially update a ContractTemplate (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `templateName` | <code>string</code> | Yes | Key property 'TemplateName' (Edm.String) |
| `payload` | <code>ContractTemplate</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateContractTemplates("GOLD", {Description: "Gold-tier annual support contract template (revised)"});
```

</div>
</details>

#### Customer Equipment Cards

<details>
<summary>listCustomerEquipmentCards</summary>

<div>

Query the CustomerEquipmentCards collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListCustomerEquipmentCardsHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListCustomerEquipmentCardsQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `CustomerEquipmentCardsCollectionResponse&#124;error`

**Sample code:**

```ballerina
CustomerEquipmentCardsCollectionResponse response = check client->listCustomerEquipmentCards(
    queries = {dollarFilter: "CustomerCode eq 'C00001'", dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#CustomerEquipmentCards",
  "value": [
    {
      "EquipmentCardNum": 205,
      "CustomerCode": "C00001",
      "CustomerName": "ACME Corp",
      "ManufacturerSerialNum": "SN-88213",
      "InternalSerialNum": "INT-004",
      "ItemCode": "A00001",
      "ItemDescription": "Laser Printer",
      "DeliveryDate": "2025-11-10",
      "ContractCode": 301,
      "StatusOfSerialNumber": "sns_Active"
    }
  ]
}
```

</div>
</details>

<details>
<summary>createCustomerEquipmentCards</summary>

<div>

Create a new CustomerEquipmentCard.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>CustomerEquipmentCard</code> | Yes | The customer equipment card to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `CustomerEquipmentCard&#124;error`

**Sample code:**

```ballerina
CustomerEquipmentCard created = check client->createCustomerEquipmentCards({
    CustomerCode: "C00001",
    ManufacturerSerialNum: "SN-88213",
    ItemCode: "A00001",
    DeliveryDate: "2025-11-10",
    ContractCode: 301
});
```

**Sample response:**

```json
{
  "EquipmentCardNum": 205,
  "CustomerCode": "C00001",
  "ManufacturerSerialNum": "SN-88213",
  "ItemCode": "A00001",
  "DeliveryDate": "2025-11-10",
  "ContractCode": 301
}
```

</div>
</details>

<details>
<summary>getCustomerEquipmentCards</summary>

<div>

Get a single CustomerEquipmentCard by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `equipmentCardNum` | <code>int:Signed32</code> | Yes | Key property 'EquipmentCardNum' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetCustomerEquipmentCardsQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `CustomerEquipmentCard&#124;error`

**Sample code:**

```ballerina
CustomerEquipmentCard card = check client->getCustomerEquipmentCards(205);
```

**Sample response:**

```json
{
  "EquipmentCardNum": 205,
  "CustomerCode": "C00001",
  "CustomerName": "ACME Corp",
  "ManufacturerSerialNum": "SN-88213",
  "ItemCode": "A00001",
  "ItemDescription": "Laser Printer",
  "DeliveryDate": "2025-11-10",
  "ContractCode": 301,
  "StatusOfSerialNumber": "sns_Active"
}
```

</div>
</details>

<details>
<summary>deleteCustomerEquipmentCards</summary>

<div>

Delete a CustomerEquipmentCard.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `equipmentCardNum` | <code>int:Signed32</code> | Yes | Key property 'EquipmentCardNum' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteCustomerEquipmentCards(205);
```

</div>
</details>

<details>
<summary>updateCustomerEquipmentCards</summary>

<div>

Partially update a CustomerEquipmentCard (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `equipmentCardNum` | <code>int:Signed32</code> | Yes | Key property 'EquipmentCardNum' (Edm.Int32) |
| `payload` | <code>CustomerEquipmentCard</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateCustomerEquipmentCards(205, {StatusOfSerialNumber: "sns_Returned"});
```

</div>
</details>

#### Knowledge Base Solutions

<details>
<summary>listKnowledgeBaseSolutions</summary>

<div>

Query the KnowledgeBaseSolutions collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListKnowledgeBaseSolutionsHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListKnowledgeBaseSolutionsQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `KnowledgeBaseSolutionsCollectionResponse&#124;error`

**Sample code:**

```ballerina
KnowledgeBaseSolutionsCollectionResponse response = check client->listKnowledgeBaseSolutions(
    queries = {dollarFilter: "ItemCode eq 'A00001'"}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#KnowledgeBaseSolutions",
  "value": [
    {
      "SolutionCode": 77,
      "ItemCode": "A00001",
      "Status": 1,
      "Solution": "Replace the fuser unit and reset the printer.",
      "Symptom": "Print jobs jam after 200 pages",
      "Cause": "Worn fuser unit",
      "Description": "Fuser replacement procedure"
    }
  ]
}
```

</div>
</details>

<details>
<summary>createKnowledgeBaseSolutions</summary>

<div>

Create a new KnowledgeBaseSolution.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>KnowledgeBaseSolution</code> | Yes | The knowledge base solution to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `KnowledgeBaseSolution&#124;error`

**Sample code:**

```ballerina
KnowledgeBaseSolution created = check client->createKnowledgeBaseSolutions({
    ItemCode: "A00001",
    Symptom: "Print jobs jam after 200 pages",
    Cause: "Worn fuser unit",
    Solution: "Replace the fuser unit and reset the printer.",
    Description: "Fuser replacement procedure"
});
```

**Sample response:**

```json
{
  "SolutionCode": 77,
  "ItemCode": "A00001",
  "Symptom": "Print jobs jam after 200 pages",
  "Cause": "Worn fuser unit",
  "Solution": "Replace the fuser unit and reset the printer.",
  "Description": "Fuser replacement procedure"
}
```

</div>
</details>

<details>
<summary>getKnowledgeBaseSolutions</summary>

<div>

Get a single KnowledgeBaseSolution by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `solutionCode` | <code>int:Signed32</code> | Yes | Key property 'SolutionCode' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetKnowledgeBaseSolutionsQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `KnowledgeBaseSolution&#124;error`

**Sample code:**

```ballerina
KnowledgeBaseSolution solution = check client->getKnowledgeBaseSolutions(77);
```

**Sample response:**

```json
{
  "SolutionCode": 77,
  "ItemCode": "A00001",
  "Status": 1,
  "Symptom": "Print jobs jam after 200 pages",
  "Cause": "Worn fuser unit",
  "Solution": "Replace the fuser unit and reset the printer.",
  "Description": "Fuser replacement procedure"
}
```

</div>
</details>

<details>
<summary>deleteKnowledgeBaseSolutions</summary>

<div>

Delete a KnowledgeBaseSolution.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `solutionCode` | <code>int:Signed32</code> | Yes | Key property 'SolutionCode' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteKnowledgeBaseSolutions(77);
```

</div>
</details>

<details>
<summary>updateKnowledgeBaseSolutions</summary>

<div>

Partially update a KnowledgeBaseSolution (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `solutionCode` | <code>int:Signed32</code> | Yes | Key property 'SolutionCode' (Edm.Int32) |
| `payload` | <code>KnowledgeBaseSolution</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateKnowledgeBaseSolutions(77, {Solution: "Replace the fuser unit, reset the printer, and run a test page."});
```

</div>
</details>

#### Queues

<details>
<summary>listQueue</summary>

<div>

Query the Queue collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListQueueHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListQueueQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `QueueCollectionResponse&#124;error`

**Sample code:**

```ballerina
QueueCollectionResponse response = check client->listQueue();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#Queue",
  "value": [
    {
      "QueueID": "SUPPORT",
      "Description": "Level 1 Support Queue",
      "Inactive": "tNO",
      "QueueManager": 12,
      "QueueEmail": "support@example.com",
      "QueueMembers": [
        {"QueueID": "SUPPORT", "MemberUserID": 15}
      ]
    }
  ]
}
```

</div>
</details>

<details>
<summary>createQueue</summary>

<div>

Create a new Queue.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>Queue</code> | Yes | The queue to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `Queue&#124;error`

**Sample code:**

```ballerina
Queue created = check client->createQueue({
    QueueID: "SUPPORT",
    Description: "Level 1 Support Queue",
    QueueManager: 12,
    QueueEmail: "support@example.com"
});
```

**Sample response:**

```json
{
  "QueueID": "SUPPORT",
  "Description": "Level 1 Support Queue",
  "QueueManager": 12,
  "QueueEmail": "support@example.com"
}
```

</div>
</details>

<details>
<summary>getQueue</summary>

<div>

Get a single Queue by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `queueID` | <code>string</code> | Yes | Key property 'QueueID' (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetQueueQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `Queue&#124;error`

**Sample code:**

```ballerina
Queue queue = check client->getQueue("SUPPORT");
```

**Sample response:**

```json
{
  "QueueID": "SUPPORT",
  "Description": "Level 1 Support Queue",
  "Inactive": "tNO",
  "QueueManager": 12,
  "QueueEmail": "support@example.com"
}
```

</div>
</details>

<details>
<summary>deleteQueue</summary>

<div>

Delete a Queue.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `queueID` | <code>string</code> | Yes | Key property 'QueueID' (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteQueue("SUPPORT");
```

</div>
</details>

<details>
<summary>updateQueue</summary>

<div>

Partially update a Queue (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `queueID` | <code>string</code> | Yes | Key property 'QueueID' (Edm.String) |
| `payload` | <code>Queue</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateQueue("SUPPORT", {QueueManager: 18});
```

</div>
</details>

#### Service Call Origins

<details>
<summary>listServiceCallOrigins</summary>

<div>

Query the ServiceCallOrigins collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallOriginsHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallOriginsQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallOriginsCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallOriginsCollectionResponse response = check client->listServiceCallOrigins();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallOrigins",
  "value": [
    {"Active": "tYES", "Description": "Customer phone call", "OriginID": 2, "Name": "Phone"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallOrigins</summary>

<div>

Create a new ServiceCallOrigin.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallOrigin</code> | Yes | The service call origin to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallOrigin&#124;error`

**Sample code:**

```ballerina
ServiceCallOrigin created = check client->createServiceCallOrigins({
    name: "Phone",
    description: "Customer phone call",
    active: "tYES"
});
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Customer phone call", "OriginID": 2, "Name": "Phone"}
```

</div>
</details>

<details>
<summary>getServiceCallOrigins</summary>

<div>

Get a single ServiceCallOrigin by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `originID` | <code>int:Signed32</code> | Yes | Key property 'OriginID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallOriginsQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallOrigin&#124;error`

**Sample code:**

```ballerina
ServiceCallOrigin origin = check client->getServiceCallOrigins(2);
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Customer phone call", "OriginID": 2, "Name": "Phone"}
```

</div>
</details>

<details>
<summary>deleteServiceCallOrigins</summary>

<div>

Delete a ServiceCallOrigin.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `originID` | <code>int:Signed32</code> | Yes | Key property 'OriginID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallOrigins(2);
```

</div>
</details>

<details>
<summary>updateServiceCallOrigins</summary>

<div>

Partially update a ServiceCallOrigin (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `originID` | <code>int:Signed32</code> | Yes | Key property 'OriginID' (Edm.Int32) |
| `payload` | <code>ServiceCallOrigin</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallOrigins(2, {description: "Inbound customer phone call"});
```

</div>
</details>

<details>
<summary>serviceCallOriginsServiceGetServiceCallOriginList</summary>

<div>

Get service call origin list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200&#124;error`

**Sample code:**

```ballerina
inline_response_200 origins = check client->serviceCallOriginsServiceGetServiceCallOriginList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallOriginsService_GetServiceCallOriginList",
  "value": [
    {"OriginID": 2, "Name": "Phone"}
  ]
}
```

</div>
</details>

#### Service Call Problem Types

<details>
<summary>listServiceCallProblemTypes</summary>

<div>

Query the ServiceCallProblemTypes collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallProblemTypesHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallProblemTypesQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallProblemTypesCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemTypesCollectionResponse response = check client->listServiceCallProblemTypes();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallProblemTypes",
  "value": [
    {"ProblemTypeID": 5, "Active": "tYES", "Description": "Hardware failure", "Name": "Hardware"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallProblemTypes</summary>

<div>

Create a new ServiceCallProblemType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallProblemType</code> | Yes | The service call problem type to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallProblemType&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemType created = check client->createServiceCallProblemTypes({
    name: "Hardware",
    description: "Hardware failure",
    active: "tYES"
});
```

**Sample response:**

```json
{"ProblemTypeID": 5, "Active": "tYES", "Description": "Hardware failure", "Name": "Hardware"}
```

</div>
</details>

<details>
<summary>getServiceCallProblemTypes</summary>

<div>

Get a single ServiceCallProblemType by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallProblemTypesQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallProblemType&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemType problemType = check client->getServiceCallProblemTypes(5);
```

**Sample response:**

```json
{"ProblemTypeID": 5, "Active": "tYES", "Description": "Hardware failure", "Name": "Hardware"}
```

</div>
</details>

<details>
<summary>deleteServiceCallProblemTypes</summary>

<div>

Delete a ServiceCallProblemType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallProblemTypes(5);
```

</div>
</details>

<details>
<summary>updateServiceCallProblemTypes</summary>

<div>

Partially update a ServiceCallProblemType (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemTypeID' (Edm.Int32) |
| `payload` | <code>ServiceCallProblemType</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallProblemTypes(5, {description: "Hardware failure or malfunction"});
```

</div>
</details>

<details>
<summary>serviceCallProblemTypesServiceGetServiceCallProblemTypeList</summary>

<div>

Get service call problem type list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200_2&#124;error`

**Sample code:**

```ballerina
inline_response_200_2 problemTypes = check client->serviceCallProblemTypesServiceGetServiceCallProblemTypeList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallProblemTypesService_GetServiceCallProblemTypeList",
  "value": [
    {"ProblemTypeID": 5, "Name": "Hardware"}
  ]
}
```

</div>
</details>

#### Service Call Problem Sub-Types

<details>
<summary>listServiceCallProblemSubTypes</summary>

<div>

Query the ServiceCallProblemSubTypes collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallProblemSubTypesHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallProblemSubTypesQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallProblemSubTypesCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemSubTypesCollectionResponse response = check client->listServiceCallProblemSubTypes();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallProblemSubTypes",
  "value": [
    {"Active": "tYES", "Description": "Won't power on", "ProblemSubTypeID": 12, "Name": "No power"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallProblemSubTypes</summary>

<div>

Create a new ServiceCallProblemSubType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallProblemSubType</code> | Yes | The service call problem sub-type to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallProblemSubType&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemSubType created = check client->createServiceCallProblemSubTypes({
    name: "No power",
    description: "Won't power on",
    active: "tYES"
});
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Won't power on", "ProblemSubTypeID": 12, "Name": "No power"}
```

</div>
</details>

<details>
<summary>getServiceCallProblemSubTypes</summary>

<div>

Get a single ServiceCallProblemSubType by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemSubTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemSubTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallProblemSubTypesQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallProblemSubType&#124;error`

**Sample code:**

```ballerina
ServiceCallProblemSubType subType = check client->getServiceCallProblemSubTypes(12);
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Won't power on", "ProblemSubTypeID": 12, "Name": "No power"}
```

</div>
</details>

<details>
<summary>deleteServiceCallProblemSubTypes</summary>

<div>

Delete a ServiceCallProblemSubType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemSubTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemSubTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallProblemSubTypes(12);
```

</div>
</details>

<details>
<summary>updateServiceCallProblemSubTypes</summary>

<div>

Partially update a ServiceCallProblemSubType (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `problemSubTypeID` | <code>int:Signed32</code> | Yes | Key property 'ProblemSubTypeID' (Edm.Int32) |
| `payload` | <code>ServiceCallProblemSubType</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallProblemSubTypes(12, {description: "Device won't power on at all"});
```

</div>
</details>

<details>
<summary>serviceCallProblemSubTypesServiceGetServiceCallProblemSubTypeList</summary>

<div>

Get service call problem sub type list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200_1&#124;error`

**Sample code:**

```ballerina
inline_response_200_1 subTypes = check client->serviceCallProblemSubTypesServiceGetServiceCallProblemSubTypeList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallProblemSubTypesService_GetServiceCallProblemSubTypeList",
  "value": [
    {"ProblemSubTypeID": 12, "Name": "No power"}
  ]
}
```

</div>
</details>

#### Service Call Solution Status

<details>
<summary>listServiceCallSolutionStatus</summary>

<div>

Query the ServiceCallSolutionStatus collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallSolutionStatusHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallSolutionStatusQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallSolutionStatusCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallSolutionStatusCollectionResponse response = check client->listServiceCallSolutionStatus();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallSolutionStatus",
  "value": [
    {"Active": "tYES", "Description": "Solution published and verified", "StatusId": 3, "Name": "Published"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallSolutionStatus</summary>

<div>

Create a new ServiceCallSolutionStatus.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallSolutionStatus</code> | Yes | The service call solution status to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallSolutionStatus&#124;error`

**Sample code:**

```ballerina
ServiceCallSolutionStatus created = check client->createServiceCallSolutionStatus({
    name: "Published",
    description: "Solution published and verified",
    active: "tYES"
});
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Solution published and verified", "StatusId": 3, "Name": "Published"}
```

</div>
</details>

<details>
<summary>getServiceCallSolutionStatus</summary>

<div>

Get a single ServiceCallSolutionStatus by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallSolutionStatusQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallSolutionStatus&#124;error`

**Sample code:**

```ballerina
ServiceCallSolutionStatus status = check client->getServiceCallSolutionStatus(3);
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Solution published and verified", "StatusId": 3, "Name": "Published"}
```

</div>
</details>

<details>
<summary>deleteServiceCallSolutionStatus</summary>

<div>

Delete a ServiceCallSolutionStatus.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallSolutionStatus(3);
```

</div>
</details>

<details>
<summary>updateServiceCallSolutionStatus</summary>

<div>

Partially update a ServiceCallSolutionStatus (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `payload` | <code>ServiceCallSolutionStatus</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallSolutionStatus(3, {description: "Solution published, verified, and archived"});
```

</div>
</details>

<details>
<summary>serviceCallSolutionStatusServiceGetServiceCallSolutionStatusList</summary>

<div>

Get service call solution status list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200_3&#124;error`

**Sample code:**

```ballerina
inline_response_200_3 statuses = check client->serviceCallSolutionStatusServiceGetServiceCallSolutionStatusList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallSolutionStatusService_GetServiceCallSolutionStatusList",
  "value": [
    {"StatusId": 3, "Name": "Published"}
  ]
}
```

</div>
</details>

#### Service Call Statuses

<details>
<summary>listServiceCallStatus</summary>

<div>

Query the ServiceCallStatus collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallStatusHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallStatusQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallStatusCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallStatusCollectionResponse response = check client->listServiceCallStatus();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallStatus",
  "value": [
    {"Active": "tYES", "Description": "Newly logged call", "StatusId": 1, "Name": "Open"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallStatus</summary>

<div>

Create a new ServiceCallStatus.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallStatus</code> | Yes | The service call status to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallStatus&#124;error`

**Sample code:**

```ballerina
ServiceCallStatus created = check client->createServiceCallStatus({
    name: "Open",
    description: "Newly logged call",
    active: "tYES"
});
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Newly logged call", "StatusId": 1, "Name": "Open"}
```

</div>
</details>

<details>
<summary>getServiceCallStatus</summary>

<div>

Get a single ServiceCallStatus by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallStatusQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallStatus&#124;error`

**Sample code:**

```ballerina
ServiceCallStatus status = check client->getServiceCallStatus(1);
```

**Sample response:**

```json
{"Active": "tYES", "Description": "Newly logged call", "StatusId": 1, "Name": "Open"}
```

</div>
</details>

<details>
<summary>deleteServiceCallStatus</summary>

<div>

Delete a ServiceCallStatus.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallStatus(1);
```

</div>
</details>

<details>
<summary>updateServiceCallStatus</summary>

<div>

Partially update a ServiceCallStatus (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `statusId` | <code>int:Signed32</code> | Yes | Key property 'StatusId' (Edm.Int32) |
| `payload` | <code>ServiceCallStatus</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallStatus(1, {description: "Newly logged, not yet assigned"});
```

</div>
</details>

<details>
<summary>serviceCallStatusServiceGetServiceCallStatusList</summary>

<div>

Get service call status list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200_4&#124;error`

**Sample code:**

```ballerina
inline_response_200_4 statuses = check client->serviceCallStatusServiceGetServiceCallStatusList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallStatusService_GetServiceCallStatusList",
  "value": [
    {"StatusId": 1, "Name": "Open"}
  ]
}
```

</div>
</details>

#### Service Call Types

<details>
<summary>listServiceCallTypes</summary>

<div>

Query the ServiceCallTypes collection.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>ListServiceCallTypesHeaders</code> | No | Headers to be sent with the request, e.g. `Prefer: odata.maxpagesize=100` to control server-side paging |
| `queries` | <code>ListServiceCallTypesQueries</code> | No | OData query options: `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ServiceCallTypesCollectionResponse&#124;error`

**Sample code:**

```ballerina
ServiceCallTypesCollectionResponse response = check client->listServiceCallTypes();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallTypes",
  "value": [
    {"Active": "tYES", "Description": "On-site hardware repair", "CallTypeID": 3, "Name": "Repair"}
  ]
}
```

</div>
</details>

<details>
<summary>createServiceCallTypes</summary>

<div>

Create a new ServiceCallType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `payload` | <code>ServiceCallType</code> | Yes | The service call type to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `ServiceCallType&#124;error`

**Sample code:**

```ballerina
ServiceCallType created = check client->createServiceCallTypes({
    name: "Repair",
    description: "On-site hardware repair",
    active: "tYES"
});
```

**Sample response:**

```json
{"Active": "tYES", "Description": "On-site hardware repair", "CallTypeID": 3, "Name": "Repair"}
```

</div>
</details>

<details>
<summary>getServiceCallTypes</summary>

<div>

Get a single ServiceCallType by key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callTypeID` | <code>int:Signed32</code> | Yes | Key property 'CallTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |
| `queries` | <code>GetServiceCallTypesQueries</code> | No | OData query options: `$expand`, `$select` |

**Returns:** `ServiceCallType&#124;error`

**Sample code:**

```ballerina
ServiceCallType callType = check client->getServiceCallTypes(3);
```

**Sample response:**

```json
{"Active": "tYES", "Description": "On-site hardware repair", "CallTypeID": 3, "Name": "Repair"}
```

</div>
</details>

<details>
<summary>deleteServiceCallTypes</summary>

<div>

Delete a ServiceCallType.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callTypeID` | <code>int:Signed32</code> | Yes | Key property 'CallTypeID' (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->deleteServiceCallTypes(3);
```

</div>
</details>

<details>
<summary>updateServiceCallTypes</summary>

<div>

Partially update a ServiceCallType (PATCH/MERGE semantics).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `callTypeID` | <code>int:Signed32</code> | Yes | Key property 'CallTypeID' (Edm.Int32) |
| `payload` | <code>ServiceCallType</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
check client->updateServiceCallTypes(3, {description: "On-site hardware repair and part replacement"});
```

</div>
</details>

<details>
<summary>serviceCallTypesServiceGetServiceCallTypeList</summary>

<div>

Get service call type list.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Headers to be sent with the request |

**Returns:** `inline_response_200_5&#124;error`

**Sample code:**

```ballerina
inline_response_200_5 callTypes = check client->serviceCallTypesServiceGetServiceCallTypeList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://<host>:50000/b1s/v1/$metadata#ServiceCallTypesService_GetServiceCallTypeList",
  "value": [
    {"CallTypeID": 3, "Name": "Repair"}
  ]
}
```

</div>
</details>

#### Session Management

<details>
<summary>logout</summary>

<div>

Ends the active SAP Business One Service Layer session.

**Parameters:**

_None_

**Returns:** `error?`

**Sample code:**

```ballerina
check client->logout();
```

</div>
</details>