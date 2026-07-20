---
connector: true
connector_name: "sap.businessone.production"
toc_max_heading_level: 4
---

# Actions

The `ballerinax/sap.businessone.production` package exposes the following clients:

Available clients:

| Client | Purpose |
|--------|---------|
| [`Client`](#client) | Manage SAP Business One production and MRP objects — bills of materials, production orders, resources, resource capacities and groups, routing stages, and sales forecasts — via the Service Layer OData API. |

---

## Client

The `Client` provides access to all production and MRP objects exposed by the SAP Business One Service Layer — bills of materials (product trees), production orders, resources, resource capacities, resource groups, resource properties, route stages, routing date calculations, and sales forecasts.

### Configuration

**Session credentials (`businessone:SessionConfig`, from `ballerinax/sap.businessone`)**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `companyDb` | <code>string</code> | Required | The SAP Business One company database to connect to |
| `username` | <code>string</code> | Required | The SAP Business One user name |
| `password` | <code>string</code> | Required | The SAP Business One user's password |

**`ConnectionConfig`**

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `httpVersion` | <code>http:HttpVersion</code> | <code>http:HTTP_2_0</code> | The HTTP version understood by the client |
| `http1Settings` | <code>http:ClientHttp1Settings</code> | <code>{}</code> | Configurations related to HTTP/1.x protocol |
| `http2Settings` | <code>http:ClientHttp2Settings</code> | <code>{}</code> | Configurations related to HTTP/2 protocol |
| `timeout` | <code>decimal</code> | <code>30</code> | The maximum time to wait (in seconds) for a response before closing the connection |
| `forwarded` | <code>string</code> | <code>"disable"</code> | The choice of setting `forwarded`/`x-forwarded` header |
| `followRedirects` | <code>http:FollowRedirects</code> | Required | Configurations associated with Redirection |
| `poolConfig` | <code>http:PoolConfiguration</code> | Required | Configurations associated with request pooling |
| `cache` | <code>http:CacheConfig</code> | <code>{}</code> | HTTP caching related configurations |
| `compression` | <code>http:Compression</code> | <code>http:COMPRESSION_AUTO</code> | Specifies the way of handling compression (`accept-encoding`) header |
| `circuitBreaker` | <code>http:CircuitBreakerConfig</code> | Required | Configurations associated with the behaviour of the Circuit Breaker |
| `retryConfig` | <code>http:RetryConfig</code> | Required | Configurations associated with retrying |
| `cookieConfig` | <code>http:CookieConfig</code> | Required | Configurations associated with cookies |
| `responseLimits` | <code>http:ResponseLimitConfigs</code> | <code>{}</code> | Configurations associated with inbound response size limits |
| `secureSocket` | <code>http:ClientSecureSocket</code> | Required | SSL/TLS-related options |
| `proxy` | <code>http:ProxyConfig</code> | Required | Proxy server related options |
| `socketConfig` | <code>http:ClientSocketConfig</code> | <code>{}</code> | Provides settings related to client socket configuration |
| `validation` | <code>boolean</code> | <code>true</code> | Enables the inbound payload validation functionality provided by the constraint package |
| `laxDataBinding` | <code>boolean</code> | <code>true</code> | Enables relaxed data binding on the client side. `nil` values are treated as optional, and absent fields are handled as `nilable` types |

### Initializing the client

```ballerina
import ballerinax/sap.businessone.production;

configurable string serviceUrl = ?;
configurable string companyDb = ?;
configurable string username = ?;
configurable string password = ?;

production:Client b1Client = check new (
    {companyDb, username, password},
    serviceUrl = serviceUrl
);
```

### Operations

#### Product Trees (BOM)

<details>
<summary>listProductTrees</summary>

<div>

Queries the `ProductTrees` collection, returning a page of bill-of-materials entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListProductTreesHeaders</code> | No | `Prefer` header for Service Layer paging control, e.g. `odata.maxpagesize=100` |
| `queries` | <code>ListProductTreesQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ProductTreesCollectionResponse|error`

**Sample code:**

```ballerina
production:ProductTreesCollectionResponse trees = check b1Client->listProductTrees(
    queries = {dollarTop: 10, dollarSelect: "TreeCode,TreeType,Quantity"}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ProductTrees",
  "value": [
    {"TreeCode": "A00001", "TreeType": "iProductionTree", "Quantity": 1}
  ]
}
```

</div>
</details>

<details>
<summary>createProductTrees</summary>

<div>

Creates a new `ProductTree` (product tree/BOM) entity.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ProductTree</code> | Yes | The product tree to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `ProductTree|error`

**Sample code:**

```ballerina
production:ProductTree created = check b1Client->createProductTrees({
    TreeCode: "A00001",
    TreeType: "iProductionTree",
    Quantity: 1,
    ProductTreeLines: [{ItemCode: "B00001", Quantity: 2}]
});
```

**Sample response:**

```json
{
  "TreeCode": "A00001",
  "TreeType": "iProductionTree",
  "Quantity": 1
}
```

</div>
</details>

<details>
<summary>getProductTrees</summary>

<div>

Retrieves a single `ProductTree` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `treeCode` | <code>string</code> | Yes | Key property `TreeCode` (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetProductTreesQueries</code> | No | `$expand`, `$select` |

**Returns:** `ProductTree|error`

**Sample code:**

```ballerina
production:ProductTree tree = check b1Client->getProductTrees("A00001");
```

**Sample response:**

```json
{
  "TreeCode": "A00001",
  "TreeType": "iProductionTree",
  "Quantity": 1
}
```

</div>
</details>

<details>
<summary>deleteProductTrees</summary>

<div>

Deletes a `ProductTree` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `treeCode` | <code>string</code> | Yes | Key property `TreeCode` (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteProductTrees("A00001");
```

</div>
</details>

<details>
<summary>updateProductTrees</summary>

<div>

Partially updates a `ProductTree` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `treeCode` | <code>string</code> | Yes | Key property `TreeCode` (Edm.String) |
| `payload` | <code>ProductTree</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateProductTrees("A00001", {Quantity: 2});
```

</div>
</details>

#### Production Orders

<details>
<summary>listProductionOrders</summary>

<div>

Queries the `ProductionOrders` collection, returning a page of production order entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListProductionOrdersHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListProductionOrdersQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ProductionOrdersCollectionResponse|error`

**Sample code:**

```ballerina
production:ProductionOrdersCollectionResponse orders = check b1Client->listProductionOrders(
    queries = {dollarFilter: "ProductionOrderStatus eq 'boposReleased'", dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ProductionOrders",
  "value": [
    {"AbsoluteEntry": 101, "ItemNo": "B00001", "ProductionOrderStatus": "boposReleased", "PlannedQuantity": 10}
  ]
}
```

</div>
</details>

<details>
<summary>createProductionOrders</summary>

<div>

Creates a new `ProductionOrder`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ProductionOrder</code> | Yes | The production order to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `ProductionOrder|error`

**Sample code:**

```ballerina
production:ProductionOrder order = check b1Client->createProductionOrders({
    ItemNo: "B00001",
    ProductionOrderType: "bopotStandard",
    PlannedQuantity: 10,
    DueDate: "2026-08-01",
    Warehouse: "01"
});
```

**Sample response:**

```json
{
  "AbsoluteEntry": 101,
  "ItemNo": "B00001",
  "ProductionOrderStatus": "boposPlanned",
  "PlannedQuantity": 10
}
```

</div>
</details>

<details>
<summary>getProductionOrders</summary>

<div>

Retrieves a single `ProductionOrder` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `absoluteEntry` | <code>int:Signed32</code> | Yes | Key property `AbsoluteEntry` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetProductionOrdersQueries</code> | No | `$expand`, `$select` |

**Returns:** `ProductionOrder|error`

**Sample code:**

```ballerina
production:ProductionOrder order = check b1Client->getProductionOrders(101);
```

**Sample response:**

```json
{
  "AbsoluteEntry": 101,
  "ItemNo": "B00001",
  "ProductionOrderStatus": "boposReleased",
  "PlannedQuantity": 10
}
```

</div>
</details>

<details>
<summary>deleteProductionOrders</summary>

<div>

Deletes a `ProductionOrder` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `absoluteEntry` | <code>int:Signed32</code> | Yes | Key property `AbsoluteEntry` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteProductionOrders(101);
```

</div>
</details>

<details>
<summary>updateProductionOrders</summary>

<div>

Partially updates a `ProductionOrder` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `absoluteEntry` | <code>int:Signed32</code> | Yes | Key property `AbsoluteEntry` (Edm.Int32) |
| `payload` | <code>ProductionOrder</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateProductionOrders(101, {DueDate: "2026-08-15"});
```

</div>
</details>

<details>
<summary>productionOrdersCancel</summary>

<div>

Invokes the bound action `Cancel` on a `ProductionOrder` (binding type `ProductionOrder`).

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `absoluteEntry` | <code>int:Signed32</code> | Yes | Key property `AbsoluteEntry` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->productionOrdersCancel(101);
```

</div>
</details>

#### Resource Capacities

<details>
<summary>listResourceCapacities</summary>

<div>

Queries the `ResourceCapacities` collection, returning a page of resource capacity entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListResourceCapacitiesHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListResourceCapacitiesQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ResourceCapacitiesCollectionResponse|error`

**Sample code:**

```ballerina
production:ResourceCapacitiesCollectionResponse capacities = check b1Client->listResourceCapacities(
    queries = {dollarFilter: "Code eq 'R00001'", dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceCapacities",
  "value": [
    {"Id": 1, "Code": "R00001", "Date": "2026-07-13", "Capacity": 8, "Type": "rctInternal"}
  ]
}
```

</div>
</details>

<details>
<summary>createResourceCapacities</summary>

<div>

Creates a new `ResourceCapacity`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ResourceCapacity</code> | Yes | The resource capacity to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `ResourceCapacity|error`

**Sample code:**

```ballerina
production:ResourceCapacity capacity = check b1Client->createResourceCapacities({
    code: "R00001",
    date: "2026-07-13",
    capacity: 8,
    'type: "rctInternal"
});
```

**Sample response:**

```json
{
  "Id": 1,
  "Code": "R00001",
  "Date": "2026-07-13",
  "Capacity": 8,
  "Type": "rctInternal"
}
```

</div>
</details>

<details>
<summary>getResourceCapacities</summary>

<div>

Retrieves a single `ResourceCapacity` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>int:Signed32</code> | Yes | Key property `Id` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetResourceCapacitiesQueries</code> | No | `$expand`, `$select` |

**Returns:** `ResourceCapacity|error`

**Sample code:**

```ballerina
production:ResourceCapacity capacity = check b1Client->getResourceCapacities(1);
```

**Sample response:**

```json
{
  "Id": 1,
  "Code": "R00001",
  "Date": "2026-07-13",
  "Capacity": 8
}
```

</div>
</details>

<details>
<summary>deleteResourceCapacities</summary>

<div>

Deletes a `ResourceCapacity` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>int:Signed32</code> | Yes | Key property `Id` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteResourceCapacities(1);
```

</div>
</details>

<details>
<summary>updateResourceCapacities</summary>

<div>

Partially updates a `ResourceCapacity` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>int:Signed32</code> | Yes | Key property `Id` (Edm.Int32) |
| `payload` | <code>ResourceCapacity</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateResourceCapacities(1, {capacity: 10});
```

</div>
</details>

<details>
<summary>resourceCapacitiesServiceGetList</summary>

<div>

Calls the `ResourceCapacitiesService_GetList` function import to get the full list of resource capacity parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200|error`

**Sample code:**

```ballerina
production:inline_response_200 result = check b1Client->resourceCapacitiesServiceGetList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceCapacitiesService_GetList",
  "value": [
    {"Code": "R00001", "Date": "2026-07-13", "Capacity": 8}
  ]
}
```

</div>
</details>

<details>
<summary>resourceCapacitiesServiceGetListWithFilter</summary>

<div>

Calls the `ResourceCapacitiesService_GetListWithFilter` function import to get a filtered list of resource capacity parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ResourceCapacitiesService_GetListWithFilter_body</code> | Yes | Filter parameters wrapping a `ResourceCapacityWithFilterParams` |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200_1|error`

**Sample code:**

```ballerina
production:inline_response_200_1 result = check b1Client->resourceCapacitiesServiceGetListWithFilter({
    resourceCapacityWithFilterParams: {code: "R00001", 'type: "rctInternal", date: "2026-07-13"}
});
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceCapacitiesService_GetListWithFilter",
  "value": [
    {"Code": "R00001", "Date": "2026-07-13", "Capacity": 8}
  ]
}
```

</div>
</details>

#### Resource Groups

<details>
<summary>listResourceGroups</summary>

<div>

Queries the `ResourceGroups` collection, returning a page of resource group entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListResourceGroupsHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListResourceGroupsQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ResourceGroupsCollectionResponse|error`

**Sample code:**

```ballerina
production:ResourceGroupsCollectionResponse groups = check b1Client->listResourceGroups(
    queries = {dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceGroups",
  "value": [
    {"Code": 1, "Name": "Machines", "Type": "rtMachine"}
  ]
}
```

</div>
</details>

<details>
<summary>createResourceGroups</summary>

<div>

Creates a new `ResourceGroup`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ResourceGroup</code> | Yes | The resource group to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `ResourceGroup|error`

**Sample code:**

```ballerina
production:ResourceGroup group = check b1Client->createResourceGroups({
    name: "Machines",
    'type: "rtMachine"
});
```

**Sample response:**

```json
{
  "Code": 1,
  "Name": "Machines",
  "Type": "rtMachine"
}
```

</div>
</details>

<details>
<summary>getResourceGroups</summary>

<div>

Retrieves a single `ResourceGroup` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetResourceGroupsQueries</code> | No | `$expand`, `$select` |

**Returns:** `ResourceGroup|error`

**Sample code:**

```ballerina
production:ResourceGroup group = check b1Client->getResourceGroups(1);
```

**Sample response:**

```json
{
  "Code": 1,
  "Name": "Machines",
  "Type": "rtMachine"
}
```

</div>
</details>

<details>
<summary>deleteResourceGroups</summary>

<div>

Deletes a `ResourceGroup` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteResourceGroups(1);
```

</div>
</details>

<details>
<summary>updateResourceGroups</summary>

<div>

Partially updates a `ResourceGroup` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `payload` | <code>ResourceGroup</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateResourceGroups(1, {name: "Heavy Machines"});
```

</div>
</details>

<details>
<summary>resourceGroupsServiceGetList</summary>

<div>

Calls the `ResourceGroupsService_GetList` function import to get the full list of resource group parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200_2|error`

**Sample code:**

```ballerina
production:inline_response_200_2 result = check b1Client->resourceGroupsServiceGetList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceGroupsService_GetList",
  "value": [
    {"Code": 1, "Name": "Machines"}
  ]
}
```

</div>
</details>

#### Resource Properties

<details>
<summary>listResourceProperties</summary>

<div>

Queries the `ResourceProperties` collection, returning a page of resource property entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListResourcePropertiesHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListResourcePropertiesQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ResourcePropertiesCollectionResponse|error`

**Sample code:**

```ballerina
production:ResourcePropertiesCollectionResponse properties = check b1Client->listResourceProperties(
    queries = {dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourceProperties",
  "value": [
    {"Code": 1, "Name": "Requires Certification"}
  ]
}
```

</div>
</details>

<details>
<summary>createResourceProperties</summary>

<div>

Creates a new `ResourceProperty`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>ResourceProperty</code> | Yes | The resource property to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `ResourceProperty|error`

**Sample code:**

```ballerina
production:ResourceProperty prop = check b1Client->createResourceProperties({
    name: "Requires Certification"
});
```

**Sample response:**

```json
{
  "Code": 1,
  "Name": "Requires Certification"
}
```

</div>
</details>

<details>
<summary>getResourceProperties</summary>

<div>

Retrieves a single `ResourceProperty` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetResourcePropertiesQueries</code> | No | `$expand`, `$select` |

**Returns:** `ResourceProperty|error`

**Sample code:**

```ballerina
production:ResourceProperty prop = check b1Client->getResourceProperties(1);
```

**Sample response:**

```json
{
  "Code": 1,
  "Name": "Requires Certification"
}
```

</div>
</details>

<details>
<summary>deleteResourceProperties</summary>

<div>

Deletes a `ResourceProperty` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteResourceProperties(1);
```

</div>
</details>

<details>
<summary>updateResourceProperties</summary>

<div>

Partially updates a `ResourceProperty` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>int:Signed32</code> | Yes | Key property `Code` (Edm.Int32) |
| `payload` | <code>ResourceProperty</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateResourceProperties(1, {name: "Certification Required"});
```

</div>
</details>

<details>
<summary>resourcePropertiesServiceGetList</summary>

<div>

Calls the `ResourcePropertiesService_GetList` function import to get the full list of resource property parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200_3|error`

**Sample code:**

```ballerina
production:inline_response_200_3 result = check b1Client->resourcePropertiesServiceGetList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourcePropertiesService_GetList",
  "value": [
    {"Code": 1, "Name": "Requires Certification"}
  ]
}
```

</div>
</details>

#### Resources

<details>
<summary>listResources</summary>

<div>

Queries the `Resources` collection, returning a page of resource entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListResourcesHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListResourcesQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `ResourcesCollectionResponse|error`

**Sample code:**

```ballerina
production:ResourcesCollectionResponse resources = check b1Client->listResources(
    queries = {dollarFilter: "Type eq 'rtMachine'", dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#Resources",
  "value": [
    {"Code": "R00001", "Name": "CNC Machine 1", "Type": "rtMachine"}
  ]
}
```

</div>
</details>

<details>
<summary>createResources</summary>

<div>

Creates a new `Resource`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>Resource</code> | Yes | The resource to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `Resource|error`

**Sample code:**

```ballerina
production:Resource resource = check b1Client->createResources({
    Code: "R00001",
    Name: "CNC Machine 1",
    Type: "rtMachine"
});
```

**Sample response:**

```json
{
  "Code": "R00001",
  "Name": "CNC Machine 1",
  "Type": "rtMachine"
}
```

</div>
</details>

<details>
<summary>getResources</summary>

<div>

Retrieves a single `Resource` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>string</code> | Yes | Key property `Code` (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetResourcesQueries</code> | No | `$expand`, `$select` |

**Returns:** `Resource|error`

**Sample code:**

```ballerina
production:Resource resource = check b1Client->getResources("R00001");
```

**Sample response:**

```json
{
  "Code": "R00001",
  "Name": "CNC Machine 1",
  "Type": "rtMachine"
}
```

</div>
</details>

<details>
<summary>deleteResources</summary>

<div>

Deletes a `Resource` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>string</code> | Yes | Key property `Code` (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteResources("R00001");
```

</div>
</details>

<details>
<summary>updateResources</summary>

<div>

Partially updates a `Resource` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>string</code> | Yes | Key property `Code` (Edm.String) |
| `payload` | <code>Resource</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateResources("R00001", {Name: "CNC Machine 1 (Refurbished)"});
```

</div>
</details>

<details>
<summary>resourcesCreateLinkedItem</summary>

<div>

Invokes the bound action `CreateLinkedItem` on a `Resource` (binding type `Resource`), creating the linked inventory item for the resource.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `code` | <code>string</code> | Yes | Key property `Code` (Edm.String) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->resourcesCreateLinkedItem("R00001");
```

</div>
</details>

<details>
<summary>resourcesServiceGetList</summary>

<div>

Calls the `ResourcesService_GetList` function import to get the full list of resource parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200_4|error`

**Sample code:**

```ballerina
production:inline_response_200_4 result = check b1Client->resourcesServiceGetList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#ResourcesService_GetList",
  "value": [
    {"Code": "R00001"}
  ]
}
```

</div>
</details>

#### Route Stages

<details>
<summary>listRouteStages</summary>

<div>

Queries the `RouteStages` collection, returning a page of route stage entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListRouteStagesHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListRouteStagesQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `RouteStagesCollectionResponse|error`

**Sample code:**

```ballerina
production:RouteStagesCollectionResponse stages = check b1Client->listRouteStages(
    queries = {dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#RouteStages",
  "value": [
    {"InternalNumber": 1, "Code": "S1", "Description": "Cutting"}
  ]
}
```

</div>
</details>

<details>
<summary>createRouteStages</summary>

<div>

Creates a new `RouteStage`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>RouteStage</code> | Yes | The route stage to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `RouteStage|error`

**Sample code:**

```ballerina
production:RouteStage stage = check b1Client->createRouteStages({
    code: "S1",
    description: "Cutting"
});
```

**Sample response:**

```json
{
  "InternalNumber": 1,
  "Code": "S1",
  "Description": "Cutting"
}
```

</div>
</details>

<details>
<summary>getRouteStages</summary>

<div>

Retrieves a single `RouteStage` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `internalNumber` | <code>int:Signed32</code> | Yes | Key property `InternalNumber` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetRouteStagesQueries</code> | No | `$expand`, `$select` |

**Returns:** `RouteStage|error`

**Sample code:**

```ballerina
production:RouteStage stage = check b1Client->getRouteStages(1);
```

**Sample response:**

```json
{
  "InternalNumber": 1,
  "Code": "S1",
  "Description": "Cutting"
}
```

</div>
</details>

<details>
<summary>deleteRouteStages</summary>

<div>

Deletes a `RouteStage` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `internalNumber` | <code>int:Signed32</code> | Yes | Key property `InternalNumber` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteRouteStages(1);
```

</div>
</details>

<details>
<summary>updateRouteStages</summary>

<div>

Partially updates a `RouteStage` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `internalNumber` | <code>int:Signed32</code> | Yes | Key property `InternalNumber` (Edm.Int32) |
| `payload` | <code>RouteStage</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateRouteStages(1, {description: "Cutting (updated)"});
```

</div>
</details>

<details>
<summary>routeStagesServiceGetList</summary>

<div>

Calls the `RouteStagesService_GetList` function import to get the full list of route stage parameter sets.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `inline_response_200_5|error`

**Sample code:**

```ballerina
production:inline_response_200_5 result = check b1Client->routeStagesServiceGetList();
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#RouteStagesService_GetList",
  "value": [
    {"InternalNumber": 1, "Code": "S1", "Description": "Cutting"}
  ]
}
```

</div>
</details>

#### Routing Date Calculation

<details>
<summary>routingDateCalculationServiceCalculate</summary>

<div>

Calls the `RoutingDateCalculationService_Calculate` function import to compute a resulting date/proportion for a routing stage over a given resource and date range.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>RoutingDateCalculationService_Calculate_body</code> | Yes | Wraps a `RoutingDateCalculationInput` with the resource code, capacity sum, and date range |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `RoutingDateCalculationOutput|error`

**Sample code:**

```ballerina
production:RoutingDateCalculationOutput result = check b1Client->routingDateCalculationServiceCalculate({
    routingDateCalculationInput: {
        resourceCode: "R00001",
        capacitySum: 16,
        calculateFromDate: "2026-07-13",
        calculateUntilDate: "2026-07-20",
        resourceAlloc: "raStartDateForwards"
    }
});
```

**Sample response:**

```json
{
  "Proportion": 0.5,
  "ResultDate": "2026-07-15"
}
```

</div>
</details>

#### Sales Forecasts

<details>
<summary>listSalesForecast</summary>

<div>

Queries the `SalesForecast` collection, returning a page of MRP sales forecast entities.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>ListSalesForecastHeaders</code> | No | `Prefer` header for Service Layer paging control |
| `queries` | <code>ListSalesForecastQueries</code> | No | `$skip`, `$top`, `$filter`, `$orderby`, `$expand`, `$inlinecount`, `$select` |

**Returns:** `SalesForecastCollectionResponse|error`

**Sample code:**

```ballerina
production:SalesForecastCollectionResponse forecasts = check b1Client->listSalesForecast(
    queries = {dollarTop: 20}
);
```

**Sample response:**

```json
{
  "odata.metadata": "https://host:50000/b1s/v1/$metadata#SalesForecast",
  "value": [
    {"Numerator": 1, "ForecastCode": "FC2026", "ForecastName": "2026 Forecast", "View": "fvtMonthly"}
  ]
}
```

</div>
</details>

<details>
<summary>createSalesForecast</summary>

<div>

Creates a new `SalesForecast`.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>SalesForecast</code> | Yes | The sales forecast to create |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `SalesForecast|error`

**Sample code:**

```ballerina
production:SalesForecast forecast = check b1Client->createSalesForecast({
    ForecastCode: "FC2026",
    ForecastName: "2026 Forecast",
    ForecastStartDate: "2026-01-01",
    ForecastEndDate: "2026-12-31",
    View: "fvtMonthly",
    SalesForecastLines: [{ItemNo: "B00001", Warehouse: "01", Quantity: 100, ForecastedDay: "2026-08-01"}]
});
```

**Sample response:**

```json
{
  "Numerator": 1,
  "ForecastCode": "FC2026",
  "ForecastName": "2026 Forecast",
  "View": "fvtMonthly"
}
```

</div>
</details>

<details>
<summary>getSalesForecast</summary>

<div>

Retrieves a single `SalesForecast` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `numerator` | <code>int:Signed32</code> | Yes | Key property `Numerator` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |
| `queries` | <code>GetSalesForecastQueries</code> | No | `$expand`, `$select` |

**Returns:** `SalesForecast|error`

**Sample code:**

```ballerina
production:SalesForecast forecast = check b1Client->getSalesForecast(1);
```

**Sample response:**

```json
{
  "Numerator": 1,
  "ForecastCode": "FC2026",
  "ForecastName": "2026 Forecast",
  "View": "fvtMonthly"
}
```

</div>
</details>

<details>
<summary>deleteSalesForecast</summary>

<div>

Deletes a `SalesForecast` by its key.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `numerator` | <code>int:Signed32</code> | Yes | Key property `Numerator` (Edm.Int32) |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->deleteSalesForecast(1);
```

</div>
</details>

<details>
<summary>updateSalesForecast</summary>

<div>

Partially updates a `SalesForecast` using PATCH/MERGE semantics.

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `numerator` | <code>int:Signed32</code> | Yes | Key property `Numerator` (Edm.Int32) |
| `payload` | <code>SalesForecast</code> | Yes | Fields to update |
| `headers` | <code>map&#60;string&#124;string[]&#62;</code> | No | Additional request headers |

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->updateSalesForecast(1, {ForecastName: "2026 Forecast (Revised)"});
```

</div>
</details>

#### Session

<details>
<summary>logout</summary>

<div>

Ends the active SAP Business One Service Layer session.

**Parameters:**

_None_

**Returns:** `error?`

**Sample code:**

```ballerina
check b1Client->logout();
```

</div>
</details>