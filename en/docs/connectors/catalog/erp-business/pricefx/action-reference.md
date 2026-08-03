---
connector: true
connector_name: "pricefx"
title: "Action Reference"
description: "Available operations in the ballerinax/pricefx connector."
---

# Action Reference

## Client

The `Client` wraps the generated `oas` client and adds the customization Pricefx's API needs on top: turning the credentials in `ConnectionConfig` into the right kind of authentication (JWT, HTTP Basic, OAuth 2.0, or a pre-signed external JWT), merging in any static headers (a two-factor authentication code, a CSRF token), and transparently re-authenticating and retrying once whenever a request comes back unauthenticated. Import `ballerinax/pricefx.oas` alongside `ballerinax/pricefx` — every operation's payload and response types live in the `oas` module.

### Configuration

#### PricefxCredentials

Pricefx account credentials and authentication options, included directly in `ConnectionConfig`. Provide exactly one of the three combinations below.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| `username` | <code>string</code> | Optional | Your Pricefx username |
| `password` | <code>string</code> | Optional | Your Pricefx password |
| `partition` | <code>string</code> | Optional | Your Pricefx partition name |
| `pricefxKey` | <code>string</code> | Optional | A Pricefx API key (contact Pricefx Support to obtain one). When set, authentication uses `POST /token`, which is faster and recommended for server-to-server integrations. When absent, authentication falls back to HTTP Basic auth (`&#60;partition&#62;/&#60;username&#62;:&#60;password&#62;`), which needs no separate API key but is slower per request |
| `oauth2ClientId` | <code>string</code> | Optional | OAuth 2.0 client identifier, as registered in Pricefx's `oauthConfiguration` |
| `oauth2ClientSecret` | <code>string</code> | Optional | OAuth 2.0 client secret, if one was configured for the client |
| `oauth2RefreshToken` | <code>string</code> | Optional | A refresh token previously obtained through Pricefx's OAuth 2.0 Authorization Code Grant flow. The connector uses it to fetch (and automatically refresh) access tokens |
| `tfaCode` | <code>string</code> | Optional | A cleartext two-factor authentication code, sent as the `PriceFx-TFA` header on every request. Only required when the calling user has TFA enabled and no session cookie exists |
| `csrfToken` | <code>string</code> | Optional | A CSRF token, sent as the `X-PriceFx-Csrf-Token` header on every request. Only required when the partition has CSRF protection enabled |
| `externalJwtSystemName` | <code>string</code> | Optional | The name of the external system trusted via Pricefx's `externalJWTConfiguration`, used together with `externalJwt` |
| `externalJwt` | <code>string</code> | Optional | A JWT signed by the external system named in `externalJwtSystemName`, sent as `Authorization: BEARER &#60;externalJwtSystemName&#62;;&#60;externalJwt&#62;` on every request |

#### ConnectionConfig

Provides a set of configurations for controlling the behaviours when communicating with the Pricefx API. Includes `PricefxCredentials` directly. The client automatically re-authenticates and retries once whenever a request comes back unauthenticated, so a long-lived client instance keeps working without manual re-initialization.

| Field | Type | Default | Description |
|-------|------|---------|-------------|
| *(all `PricefxCredentials` fields)* | | | See above |
| `httpVersion` | <code>http:HttpVersion</code> | <code>http:HTTP_2_0</code> | The HTTP version understood by the client |
| `http1Settings` | <code>oas:ClientHttp1Settings</code> | Optional | Configurations related to HTTP/1.x protocol |
| `http2Settings` | <code>http:ClientHttp2Settings</code> | Optional | Configurations related to HTTP/2 protocol |
| `timeout` | <code>decimal</code> | <code>60</code> | The maximum time to wait (in seconds) for a response before closing the connection |
| `forwarded` | <code>string</code> | <code>"disable"</code> | The choice of setting `forwarded`/`x-forwarded` header |
| `poolConfig` | <code>http:PoolConfiguration</code> | Optional | Configurations associated with request pooling |
| `cache` | <code>http:CacheConfig</code> | Optional | HTTP caching related configurations |
| `compression` | <code>http:Compression</code> | <code>http:COMPRESSION_AUTO</code> | Specifies the way of handling compression (`accept-encoding`) header |
| `circuitBreaker` | <code>http:CircuitBreakerConfig</code> | Optional | Configurations associated with the behaviour of the Circuit Breaker |
| `retryConfig` | <code>http:RetryConfig</code> | Optional | Configurations associated with retrying |
| `responseLimits` | <code>http:ResponseLimitConfigs</code> | Optional | Configurations associated with inbound response size limits |
| `secureSocket` | <code>http:ClientSecureSocket</code> | Optional | SSL/TLS-related options |
| `proxy` | <code>http:ProxyConfig</code> | Optional | Proxy server related options |
| `validation` | <code>boolean</code> | <code>true</code> | Enables the inbound payload validation functionality provided by the constraint package |
| `laxDataBinding` | <code>boolean</code> | <code>true</code> | Enables relaxed data binding on the client side, treating `nil` values and absent fields as optional |

### Initializing the client

```ballerina
import ballerinax/pricefx;
import ballerinax/pricefx.oas;

configurable string username = ?;
configurable string password = ?;
configurable string partition = ?;
configurable string serviceUrl = ?;

pricefx:Client pricefxClient = check new ({username, password, partition}, serviceUrl);
```

### Operations

#### Authentication

<details>
<summary>createAuthToken</summary>

<div>

Get an Authentication Token (API V2 only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>oas:CreateAuthTokenHeaders</code> | Yes | Headers to be sent with the request |
| `payload` | <code>oas:GetAuthenticationTokenAPIv2Request</code> | Yes |  |

**Returns:** `oas:tokenResponse|error`

**Sample code:**

```ballerina
oas:tokenResponse result = check pricefxClient->createAuthToken(headers, payload);
```

</div>
</details>

<details>
<summary>deleteAuthToken</summary>

<div>

Delete an Authentication Token (API V2 only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>oas:DeleteAuthTokenHeaders</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->deleteAuthToken();
```

</div>
</details>

<details>
<summary>login</summary>

<div>

User Login (V1)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UserLoginResponse|error`

**Sample code:**

```ballerina
oas:UserLoginResponse result = check pricefxClient->login();
```

</div>
</details>

<details>
<summary>oauthAuthorize</summary>

<div>

OAuth Authorization Request

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:OauthAuthorizeQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->oauthAuthorize(queries);
```

</div>
</details>

<details>
<summary>oauthToken</summary>

<div>

Access Token Request

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:OauthTokenQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:OAuthTokenResponse|error`

**Sample code:**

```ballerina
oas:OAuthTokenResponse result = check pricefxClient->oauthToken(queries);
```

</div>
</details>

<details>
<summary>refreshAuthToken</summary>

<div>

Refresh an Authentication Token (API V2 only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>oas:RefreshAuthTokenHeaders</code> | Yes | Headers to be sent with the request |
| `payload` | <code>oas:TokenRefreshBody</code> | Yes | Provide the referesh token |

**Returns:** `oas:tokenResponse|error`

**Sample code:**

```ballerina
oas:tokenResponse result = check pricefxClient->refreshAuthToken(headers, payload);
```

</div>
</details>

<details>
<summary>samlSignOn</summary>

<div>

Authenticate with SAML

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:SamlSignOnQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->samlSignOn(queries);
```

</div>
</details>

#### User Admin

<details>
<summary>addUser</summary>

<div>

Add a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddUserRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:userResponse|error`

**Sample code:**

```ballerina
oas:userResponse result = check pricefxClient->addUser(payload);
```

</div>
</details>

<details>
<summary>assignBusinessRole</summary>

<div>

Assign a Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignBusinessRoleRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:AssignBusinessRoleResponse result = check pricefxClient->assignBusinessRole(payload);
```

</div>
</details>

<details>
<summary>assignBusinessRoleToUser</summary>

<div>

Assign a Business Role to a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to assign a role to. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `payload` | <code>oas:AssignBusinessRoleToUserRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignBusinessRoleToUserResponse|error`

**Sample code:**

```ballerina
oas:AssignBusinessRoleToUserResponse result = check pricefxClient->assignBusinessRoleToUser(userId, payload);
```

</div>
</details>

<details>
<summary>assignGroupToBusinessRole</summary>

<div>

Assign a Group to a Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignGroupToBusinessRoleRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignGroupToBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:AssignGroupToBusinessRoleResponse result = check pricefxClient->assignGroupToBusinessRole(payload);
```

</div>
</details>

<details>
<summary>assignRoleToBusinessRole</summary>

<div>

Assign a Role to a Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignRoleToBusinessRoleRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignRoleToBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:AssignRoleToBusinessRoleResponse result = check pricefxClient->assignRoleToBusinessRole(payload);
```

</div>
</details>

<details>
<summary>assignRoleToUser</summary>

<div>

Assign a Role to a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to assign a role to. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `payload` | <code>oas:AssignRoleToUserRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignRoleToUserResponse|error`

**Sample code:**

```ballerina
oas:AssignRoleToUserResponse result = check pricefxClient->assignRoleToUser(userId, payload);
```

</div>
</details>

<details>
<summary>assignRoleToUsers</summary>

<div>

Assign a Role to Users

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignRoleToUsersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignRoleToUsersResponse|error`

**Sample code:**

```ballerina
oas:AssignRoleToUsersResponse result = check pricefxClient->assignRoleToUsers(payload);
```

</div>
</details>

<details>
<summary>assignUserGroupToUsers</summary>

<div>

Assign a User Group to Users

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignUserGroupToUsersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignUserGroupToUsersResponse|error`

**Sample code:**

```ballerina
oas:AssignUserGroupToUsersResponse result = check pricefxClient->assignUserGroupToUsers(payload);
```

</div>
</details>

<details>
<summary>assignUserToUserGroup</summary>

<div>

Assign a User to a User Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to add to the group. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `payload` | <code>oas:AssignUserToUserGroupRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AssignUserToUserGroupResponse|error`

**Sample code:**

```ballerina
oas:AssignUserToUserGroupResponse result = check pricefxClient->assignUserToUserGroup(userId, payload);
```

</div>
</details>

<details>
<summary>changeCurrentUserPassword</summary>

<div>

Change a Current User Password

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ChangeCurrentUserPasswordRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ChangeCurrentUserPasswordResponse|error`

**Sample code:**

```ballerina
oas:ChangeCurrentUserPasswordResponse result = check pricefxClient->changeCurrentUserPassword(payload);
```

</div>
</details>

<details>
<summary>changeUserPassword</summary>

<div>

Change a User Password

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | Enter the ID of the user whose password you want to change. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `payload` | <code>oas:ChangeUserPasswordRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ChangeUserPasswordResponse|error`

**Sample code:**

```ballerina
oas:ChangeUserPasswordResponse result = check pricefxClient->changeUserPassword(userId, payload);
```

</div>
</details>

<details>
<summary>copyRoles</summary>

<div>

Copy Roles + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CopyRolesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyRolesResponse|error`

**Sample code:**

```ballerina
oas:CopyRolesResponse result = check pricefxClient->copyRoles(payload);
```

</div>
</details>

<details>
<summary>copyUser</summary>

<div>

Copy a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userid` | <code>string</code> | Yes | The ID of the user you want to copy. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyUserResponse|error`

**Sample code:**

```ballerina
oas:CopyUserResponse result = check pricefxClient->copyUser(userid);
```

</div>
</details>

<details>
<summary>deleteBusinessRole</summary>

<div>

Delete a Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteBusinessRoleRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:DeleteBusinessRoleResponse result = check pricefxClient->deleteBusinessRole(payload);
```

</div>
</details>

<details>
<summary>deleteUser</summary>

<div>

Delete a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteUserRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:userResponse|error`

**Sample code:**

```ballerina
oas:userResponse result = check pricefxClient->deleteUser(payload);
```

</div>
</details>

<details>
<summary>deleteUserGroup</summary>

<div>

Delete a User Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteUserGroupRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteUserGroupResponse|error`

**Sample code:**

```ballerina
oas:DeleteUserGroupResponse result = check pricefxClient->deleteUserGroup(payload);
```

</div>
</details>

<details>
<summary>generateJwtToken</summary>

<div>

Generate a JWT Token

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:GenerateJWTTokenRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GenerateJWTTokenResponse|error`

**Sample code:**

```ballerina
oas:GenerateJWTTokenResponse result = check pricefxClient->generateJwtToken(payload);
```

</div>
</details>

<details>
<summary>generateTimedJwtToken</summary>

<div>

Generate a JWT Token (time limited)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `minutes` | <code>string</code> | Yes | The number of minutes in which the token expires |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GenerateJWTTokenTimeLimitedResponse|error`

**Sample code:**

```ballerina
oas:GenerateJWTTokenTimeLimitedResponse result = check pricefxClient->generateTimedJwtToken(minutes);
```

</div>
</details>

<details>
<summary>getOneTimeToken</summary>

<div>

Get a One Time Token

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetOneTimeTokenResponse|error`

**Sample code:**

```ballerina
oas:GetOneTimeTokenResponse result = check pricefxClient->getOneTimeToken();
```

</div>
</details>

<details>
<summary>getUserAuditReport</summary>

<div>

Get a User Audit Report

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"R"&#124;"UG"&#124;"BR"</code> | Yes | Specify whether you want to retrieve a report based on user roles (`R`), user groups (`UG`), or business roles (`BR`) |
| `id` | <code>string</code> | Yes | Specify the `id`of the user role, user group, or business role for which you want to retrieve users. Call the `/fetch/R`, `/fetch/UG`, or `/fetch/BR` endpoint to retrieve a list with corresponding user roles, user groups, or business roles |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UserAuditReportEnvelope|error`

**Sample code:**

```ballerina
oas:UserAuditReportEnvelope result = check pricefxClient->getUserAuditReport(typeCode, id, payload);
```

</div>
</details>

<details>
<summary>listGroupsOfBusinessRole</summary>

<div>

List Groups of the Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `businessroleId` | <code>string</code> | Yes | The ID of the business role you want to retrieve user roles for. The `businessroleId` is the `typedId` without the `BR` suffix. For example, `businessroleId` of the **53.BR** is **53** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListGroupsOfBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:ListGroupsOfBusinessRoleResponse result = check pricefxClient->listGroupsOfBusinessRole(businessroleId);
```

</div>
</details>

<details>
<summary>listRolesOfBusinessRole</summary>

<div>

List Roles of the Business Role

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `businessroleId` | <code>string</code> | Yes | The ID of the business role you want to retrieve user roles for. The `businessroleId` is the `typedId` without the `BR` suffix. For example, `businessroleId` of the **53.BR** is **53** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRolesOfBusinessRoleResponse|error`

**Sample code:**

```ballerina
oas:ListRolesOfBusinessRoleResponse result = check pricefxClient->listRolesOfBusinessRole(businessroleId);
```

</div>
</details>

<details>
<summary>listUserSBusinessRoles</summary>

<div>

List User's Business Roles

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to retrieve business roles for. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUserBusinessRolesResponse|error`

**Sample code:**

```ballerina
oas:ListUserBusinessRolesResponse result = check pricefxClient->listUserSBusinessRoles(userId);
```

</div>
</details>

<details>
<summary>listUserSRoles</summary>

<div>

List User's Roles

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to retrieve roles for. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUserRolesResponse|error`

**Sample code:**

```ballerina
oas:ListUserRolesResponse result = check pricefxClient->listUserSRoles(userId);
```

</div>
</details>

<details>
<summary>listUserSUserGroups</summary>

<div>

List User's User Groups

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `userId` | <code>string</code> | Yes | The ID of the user you want to retrieve groups for. The `userId` is the `typedId` without the `U` suffix. For example, `userId` of the **2147490806.U** is **2147490806** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUsersUserGroupsResponse|error`

**Sample code:**

```ballerina
oas:ListUsersUserGroupsResponse result = check pricefxClient->listUserSUserGroups(userId);
```

</div>
</details>

<details>
<summary>listUsers</summary>

<div>

List Users

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListUsersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUsersResponse|error`

**Sample code:**

```ballerina
oas:ListUsersResponse result = check pricefxClient->listUsers(payload);
```

</div>
</details>

<details>
<summary>updateUser</summary>

<div>

Update a User

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateUserRequest</code> | Yes | Specify the user by `typedId` and define the new value of the field you want to update in the `data` object |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:userResponse|error`

**Sample code:**

```ballerina
oas:userResponse result = check pricefxClient->updateUser(payload);
```

</div>
</details>

#### Products

<details>
<summary>addProduct</summary>

<div>

Add a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddProductRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->addProduct(payload);
```

</div>
</details>

<details>
<summary>bulkInsertProducts</summary>

<div>

Insert Bulk Products

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:InsertBulkProductsRequest</code> | Yes | Specify product field names in the `header` object and fields values in the `data` object.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:loaddataResponse|error`

**Sample code:**

```ballerina
oas:loaddataResponse result = check pricefxClient->bulkInsertProducts(payload);
```

</div>
</details>

<details>
<summary>deleteProduct</summary>

<div>

Delete a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteProductRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteProductResponse|error`

**Sample code:**

```ballerina
oas:DeleteProductResponse result = check pricefxClient->deleteProduct(payload);
```

</div>
</details>

<details>
<summary>getProductBomTree</summary>

<div>

List BoM for a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sku` | <code>string</code> | Yes | The `sku` of the product you want to retrieve the Bill of Materials for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListBoMForProductResponse|error`

**Sample code:**

```ballerina
oas:ListBoMForProductResponse result = check pricefxClient->getProductBomTree(sku);
```

</div>
</details>

<details>
<summary>listProducts</summary>

<div>

List Products

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListProductsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->listProducts(payload);
```

</div>
</details>

<details>
<summary>listRecommendations</summary>

<div>

List Recommendations

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListRecommendationsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRecommendationsEnvelope|error`

**Sample code:**

```ballerina
oas:ListRecommendationsEnvelope result = check pricefxClient->listRecommendations(payload);
```

</div>
</details>

<details>
<summary>searchProducts</summary>

<div>

Search a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SearchProductRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SearchProductResponse|error`

**Sample code:**

```ballerina
oas:SearchProductResponse result = check pricefxClient->searchProducts(payload);
```

</div>
</details>

<details>
<summary>searchProductsByQuery</summary>

<div>

Search a Product (URL)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `query` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SearchProductURLResponse|error`

**Sample code:**

```ballerina
oas:SearchProductURLResponse result = check pricefxClient->searchProductsByQuery(query);
```

</div>
</details>

<details>
<summary>updateProduct</summary>

<div>

Update a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateProductRequest</code> | Yes | Updates specified fields of the record. Only one record can be updated per request (unless batched).&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->updateProduct(payload);
```

</div>
</details>

<details>
<summary>upsertProduct</summary>

<div>

Upsert a Product

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertProductRequest</code> | Yes | Either `sku` or `typedId` must be specified in order to *update* an existing product |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->upsertProduct(payload);
```

</div>
</details>

#### Product Extensions

<details>
<summary>deleteProductExtension</summary>

<div>

Delete a Product Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteProductExtensionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteProductExtensionResponse|error`

**Sample code:**

```ballerina
oas:DeleteProductExtensionResponse result = check pricefxClient->deleteProductExtension(payload);
```

</div>
</details>

<details>
<summary>getProductAttributeMeta</summary>

<div>

Get Product Attribute Meta

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ProductAttributeMetaEnvelope|error`

**Sample code:**

```ballerina
oas:ProductAttributeMetaEnvelope result = check pricefxClient->getProductAttributeMeta(payload);
```

</div>
</details>

<details>
<summary>insertBulkProductExtensions</summary>

<div>

Insert Bulk Product Extensions

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:InsertBulkProductExtensionsRequest</code> | Yes | Specify product extension field names in the `header` object and field values in the `data` object |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->insertBulkProductExtensions(payload);
```

</div>
</details>

<details>
<summary>listProductExtensionObjects</summary>

<div>

List Product Extension Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `productMasterExtensionName` | <code>string</code> | Yes | Enter the name of Product Extension you want to retrieve objects from. You can find the name in **Administration** &gt; **Configuration** &gt; **Master Data** &gt; **Product Master Extension** or using the **/configurationmanager.get/productextension** endpoint |
| `payload` | <code>oas:ListProductExtensionObjectsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListProductExtensionObjectsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ProductExtensionResponse|error`

**Sample code:**

```ballerina
oas:ProductExtensionResponse result = check pricefxClient->listProductExtensionObjects(productMasterExtensionName, payload, queries);
```

</div>
</details>

<details>
<summary>upsertProductExtension</summary>

<div>

Upsert a Product Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertProductExtensionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->upsertProductExtension(payload);
```

</div>
</details>

#### Product Image

<details>
<summary>deleteUploadSlotViaGet</summary>

<div>

3. Delete an Upload Slot

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `slotId` | <code>string</code> | Yes | Enter the ID of the slot you want to delete |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteUploadSlotResponse|error`

**Sample code:**

```ballerina
oas:DeleteUploadSlotResponse result = check pricefxClient->deleteUploadSlotViaGet(slotId);
```

</div>
</details>

<details>
<summary>getNewUploadSlot</summary>

<div>

1. Create an Upload Slot

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreateUploadSlotResponse|error`

**Sample code:**

```ballerina
oas:CreateUploadSlotResponse result = check pricefxClient->getNewUploadSlot();
```

</div>
</details>

<details>
<summary>uploadProductImage</summary>

<div>

2. Upload a File + request -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `slotId` | <code>string</code> | Yes | Enter the ID of the slot you want to use for the upload |
| `sku` | <code>string</code> | Yes | Enter the `sku` of the product you want to add the product image to |
| `payload` | <code>oas:TypedIdslotIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->uploadProductImage(slotId, sku, payload);
```

</div>
</details>

#### Competition Data

<details>
<summary>getProductCompetition</summary>

<div>

Get Competition Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:GetCompetitionDataRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCompetitionDataResponse|error`

**Sample code:**

```ballerina
oas:GetCompetitionDataResponse result = check pricefxClient->getProductCompetition(payload);
```

</div>
</details>

<details>
<summary>getProductSetCompetition</summary>

<div>

Get a Product Set

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `label` | <code>string</code> | Yes | Enter the name of the product set you want to retrieve |
| `payload` | <code>oas:GetProductSetRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetProductSetResponse|error`

**Sample code:**

```ballerina
oas:GetProductSetResponse result = check pricefxClient->getProductSetCompetition(label, payload);
```

</div>
</details>

<details>
<summary>importProductCompetition</summary>

<div>

Import Competition Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ImportCompetitionDataRequest</code> | Yes | The competition product details |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ImportCompetitionDataResponse|error`

**Sample code:**

```ballerina
oas:ImportCompetitionDataResponse result = check pricefxClient->importProductCompetition(payload);
```

</div>
</details>

<details>
<summary>listProductSets</summary>

<div>

List Product Sets

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListProductSetsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListProductSetsResponse|error`

**Sample code:**

```ballerina
oas:ListProductSetsResponse result = check pricefxClient->listProductSets(payload);
```

</div>
</details>

#### Customers

<details>
<summary>addCustomer</summary>

<div>

Add a Customer

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCustomerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:customerResponse|error`

**Sample code:**

```ballerina
oas:customerResponse result = check pricefxClient->addCustomer(payload);
```

</div>
</details>

<details>
<summary>assignCustomers</summary>

<div>

Assign Customers

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AssignCustomersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:assignmentResponse|error`

**Sample code:**

```ballerina
oas:assignmentResponse result = check pricefxClient->assignCustomers(payload);
```

</div>
</details>

<details>
<summary>bulkInsertCustomers</summary>

<div>

Insert Bulk Customers

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:InsertBulkCustomersRequest</code> | Yes | Specify customer field names in the `header` object and fields values in the `data` object.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:loaddataResponse|error`

**Sample code:**

```ballerina
oas:loaddataResponse result = check pricefxClient->bulkInsertCustomers(payload);
```

</div>
</details>

<details>
<summary>deleteCustomer</summary>

<div>

Delete a Customer

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCustomerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCustomerResponse|error`

**Sample code:**

```ballerina
oas:DeleteCustomerResponse result = check pricefxClient->deleteCustomer(payload);
```

</div>
</details>

<details>
<summary>getCustomer</summary>

<div>

Get a Customer

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Customer you want to retrieve details for. The `id` is the `typedId` without the **C** suffix. For example, the `id` parameter of the item with `typedId` = **2147492200.C**  is **2147492200** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:customerResponse|error`

**Sample code:**

```ballerina
oas:customerResponse result = check pricefxClient->getCustomer(id);
```

</div>
</details>

<details>
<summary>listCustomerAssignments</summary>

<div>

List Customer Assignments

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the entity you want to retrieve assignments for |
| `payload` | <code>oas:ListCustomerAssignmentsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:assignmentResponse|error`

**Sample code:**

```ballerina
oas:assignmentResponse result = check pricefxClient->listCustomerAssignments(typedId, payload);
```

</div>
</details>

<details>
<summary>listCustomers</summary>

<div>

List Customers

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCustomersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:customerResponse|error`

**Sample code:**

```ballerina
oas:customerResponse result = check pricefxClient->listCustomers(payload);
```

</div>
</details>

<details>
<summary>updateCustomer</summary>

<div>

Update a Customer + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCustomerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:customerResponse|error`

**Sample code:**

```ballerina
oas:customerResponse result = check pricefxClient->updateCustomer(payload);
```

</div>
</details>

<details>
<summary>upsertCustomer</summary>

<div>

Upsert a Customer

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertCustomerRequest</code> | Yes | If the customer does not exist yet, at least the `customerId` must be specified in the payload.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:customerResponse|error`

**Sample code:**

```ballerina
oas:customerResponse result = check pricefxClient->upsertCustomer(payload);
```

</div>
</details>

#### Customer Extensions

<details>
<summary>deleteCustomerExtension</summary>

<div>

Delete a Customer Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCustomerExtensionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCustomerExtensionResponse|error`

**Sample code:**

```ballerina
oas:DeleteCustomerExtensionResponse result = check pricefxClient->deleteCustomerExtension(payload);
```

</div>
</details>

<details>
<summary>insertBulkCustomerExtensions</summary>

<div>

Insert Bulk Customer Extensions

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:InsertBulkCustomerExtensionsRequest</code> | Yes | Specify customer extension field names in the `header` object and field values in the `data` object.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:loaddataResponse|error`

**Sample code:**

```ballerina
oas:loaddataResponse result = check pricefxClient->insertBulkCustomerExtensions(payload);
```

</div>
</details>

<details>
<summary>listCustomerExtensionObjects</summary>

<div>

List Customer Extension Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `customerMasterExtensionName` | <code>string</code> | Yes | Enter the name of Customer Extension you want to retrieve objects from. You can find the name in **Administration** &gt; **Configuration** &gt; **Master Data** &gt; **Customer Master Extension** or using the **/configurationmanager.get/customerextension** endpoint |
| `payload` | <code>oas:ListCustomerExtensionObjectsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListCustomerExtensionObjectsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ListCustomerExtensionObjectsResponse|error`

**Sample code:**

```ballerina
oas:ListCustomerExtensionObjectsResponse result = check pricefxClient->listCustomerExtensionObjects(customerMasterExtensionName, payload, queries);
```

</div>
</details>

<details>
<summary>uploadFileToPxCxSx</summary>

<div>

Upload a File to PX/CX/SX + request -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"PX"&#124;"CX"&#124;"SX"</code> | Yes | Type code of the table you want to upload the file to |
| `target` | <code>string</code> | Yes | The name of the PX/CX/SX table |
| `uploadSlotId` | <code>string</code> | Yes | `id` of the upload slot. Use the **uploadslotmanager.newuploadslot** endpoint to retrieve the `id` |
| `payload` | <code>oas:TargetuploadSlotIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:UploadFileToPxCxSxQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->uploadFileToPxCxSx(typeCode, target, uploadSlotId, payload, queries);
```

</div>
</details>

<details>
<summary>upsertCustomerExtension</summary>

<div>

Upsert a Customer Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertCustomerExtensionRequest</code> | Yes | **Please note**: The data sent in your request might be different from our sample request schema. Custom fields (`attribute1`..`attribute30`) can be retrieved using the **`/fetch/CXAM`** operation |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpsertCustomerExtensionResponse|error`

**Sample code:**

```ballerina
oas:UpsertCustomerExtensionResponse result = check pricefxClient->upsertCustomerExtension(payload);
```

</div>
</details>

#### Sellers

<details>
<summary>addSeller</summary>

<div>

Add a Seller

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddSellerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddSellerEnvelope|error`

**Sample code:**

```ballerina
oas:AddSellerEnvelope result = check pricefxClient->addSeller(payload);
```

</div>
</details>

<details>
<summary>deleteSeller</summary>

<div>

Delete a Seller

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteSellerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteSellerEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteSellerEnvelope result = check pricefxClient->deleteSeller(payload);
```

</div>
</details>

<details>
<summary>listSellers</summary>

<div>

List Sellers

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListSellersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListSellersEnvelope|error`

**Sample code:**

```ballerina
oas:ListSellersEnvelope result = check pricefxClient->listSellers(payload);
```

</div>
</details>

<details>
<summary>updateSeller</summary>

<div>

Update a Seller

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateSellerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateSellerEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateSellerEnvelope result = check pricefxClient->updateSeller(payload);
```

</div>
</details>

#### Seller Extensions

<details>
<summary>addSellerExtension</summary>

<div>

Add a Seller Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddSellerExtensionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddSellerExtensionResponse|error`

**Sample code:**

```ballerina
oas:AddSellerExtensionResponse result = check pricefxClient->addSellerExtension(payload);
```

</div>
</details>

<details>
<summary>deleteSellerExtension</summary>

<div>

Delete a Seller Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteSellerExtensionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteSellerExtensionResponse|error`

**Sample code:**

```ballerina
oas:DeleteSellerExtensionResponse result = check pricefxClient->deleteSellerExtension(payload);
```

</div>
</details>

<details>
<summary>getSellerExtension</summary>

<div>

Get a Seller Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sellerId` | <code>string</code> | Yes | The `SellerId` of the seller in the Seller Extension table you want to retrieve details for |
| `sXCategory` | <code>string</code> | Yes | The Seller Extension category (the `Name` from the *Seller Master Extension* table) |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SellerExtensionEnvelope|error`

**Sample code:**

```ballerina
oas:SellerExtensionEnvelope result = check pricefxClient->getSellerExtension(sellerId, sXCategory);
```

</div>
</details>

<details>
<summary>importSellerExtensionFile</summary>

<div>

Import a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sXCategory` | <code>string</code> | Yes | The Seller Extension category (the `Name` from the *Seller Master Extension* table) |
| `slotId` | <code>string</code> | Yes | The ID that is returned by the **/uploadmanager.newuploadslot** (Create an Upload Slot) endpoint |
| `payload` | <code>oas:ImportSXFileRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ImportSellerExtensionFileQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->importSellerExtensionFile(sXCategory, slotId, payload, queries);
```

</div>
</details>

<details>
<summary>insertBulkSellerExtensions</summary>

<div>

Insert Bulk Seller Extensions

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:InsertBulkProductExtensionsRequest1</code> | Yes | Specify seller extension field names in the `header` object and field values in the `data` object |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->insertBulkSellerExtensions(payload);
```

</div>
</details>

<details>
<summary>listSellerExtensions</summary>

<div>

List Seller Extensions

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sXCategory` | <code>string</code> | Yes | The Seller Extension category (the `Name` from the *Seller Master Extension* table) |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SellerExtensionEnvelope|error`

**Sample code:**

```ballerina
oas:SellerExtensionEnvelope result = check pricefxClient->listSellerExtensions(sXCategory);
```

</div>
</details>

<details>
<summary>updateSellerExtension</summary>

<div>

Update a Seller Extension

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateSXBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateSellerExtensionEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateSellerExtensionEnvelope result = check pricefxClient->updateSellerExtension(payload);
```

</div>
</details>

#### Condition Records

<details>
<summary>addConditionRecordItemMeta</summary>

<div>

Add a Condition Record Item Attribute Meta

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCRCIMBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordItemMetaOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordItemMetaOperationEnvelope result = check pricefxClient->addConditionRecordItemMeta(payload);
```

</div>
</details>

<details>
<summary>addConditionRecordSet</summary>

<div>

Add a Condition Record Set

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCRCSBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordSetOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordSetOperationEnvelope result = check pricefxClient->addConditionRecordSet(payload);
```

</div>
</details>

<details>
<summary>deleteConditionRecordItemMeta</summary>

<div>

Delete a Condition Record Item Attribute Meta

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCRCIMBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordItemMetaOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordItemMetaOperationEnvelope result = check pricefxClient->deleteConditionRecordItemMeta(payload);
```

</div>
</details>

<details>
<summary>deleteConditionRecordSet</summary>

<div>

Delete a Condition Records Set

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DcrmanagerDeletemassopidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordSetOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordSetOperationEnvelope result = check pricefxClient->deleteConditionRecordSet(payload);
```

</div>
</details>

<details>
<summary>getConditionRecordItem</summary>

<div>

Get a Condition Record Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordItemEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordItemEnvelope result = check pricefxClient->getConditionRecordItem(payload);
```

</div>
</details>

<details>
<summary>getConditionRecordItemMeta</summary>

<div>

Get a Condition Record Item Attribute Meta

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:FetchCRCIMBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordItemMetaEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordItemMetaEnvelope result = check pricefxClient->getConditionRecordItemMeta(payload);
```

</div>
</details>

<details>
<summary>getConditionRecordSetItems</summary>

<div>

Get Condition Record Set Items With Set Id Validation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ConditionrecordsetFetchCRCI3Body</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordSetItemsEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordSetItemsEnvelope result = check pricefxClient->getConditionRecordSetItems(payload);
```

</div>
</details>

<details>
<summary>listConditionRecordSets</summary>

<div>

List Condition Record Sets

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListConditionRecordSetsEnvelope|error`

**Sample code:**

```ballerina
oas:ListConditionRecordSetsEnvelope result = check pricefxClient->listConditionRecordSets(payload);
```

</div>
</details>

<details>
<summary>updateConditionRecordItemMeta</summary>

<div>

Update a Condition Record Item Attribute Meta + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCRCIMBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateConditionRecordItemMetaEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateConditionRecordItemMetaEnvelope result = check pricefxClient->updateConditionRecordItemMeta(payload);
```

</div>
</details>

<details>
<summary>updateConditionRecordSet</summary>

<div>

Update a Condition Record Set

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the ConditionRecordSet object you want to update |
| `payload` | <code>oas:ConditionrecordsetUpdateidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConditionRecordSetOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConditionRecordSetOperationEnvelope result = check pricefxClient->updateConditionRecordSet(id, payload);
```

</div>
</details>

#### Price Lists

<details>
<summary>addPriceListType</summary>

<div>

Add a Price List Type + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddPLTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:PriceListTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:PriceListTypeOperationEnvelope result = check pricefxClient->addPriceListType(payload);
```

</div>
</details>

<details>
<summary>calculatePriceList</summary>

<div>

Calculate a Pricelist

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List you want to calculate. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `payload` | <code>oas:PricelistmanagerCalculateidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculatePricelistResponse|error`

**Sample code:**

```ballerina
oas:CalculatePricelistResponse result = check pricefxClient->calculatePriceList(id, payload);
```

</div>
</details>

<details>
<summary>createPriceList</summary>

<div>

Create a Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CreatePriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreatePriceListResponse|error`

**Sample code:**

```ballerina
oas:CreatePriceListResponse result = check pricefxClient->createPriceList(payload);
```

</div>
</details>

<details>
<summary>createPriceListRevision</summary>

<div>

Create a Revision

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List you want to create a revision for. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `payload` | <code>oas:CreateRevisionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricelistitemResponse|error`

**Sample code:**

```ballerina
oas:pricelistitemResponse result = check pricefxClient->createPriceListRevision(id, payload);
```

</div>
</details>

<details>
<summary>deletePriceList</summary>

<div>

Delete a Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeletePriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeletePriceListResponse|error`

**Sample code:**

```ballerina
oas:DeletePriceListResponse result = check pricefxClient->deletePriceList(payload);
```

</div>
</details>

<details>
<summary>deletePriceListItems</summary>

<div>

Delete a Price List Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | Enter the ID of the Price List where you want to delete an item from |
| `payload` | <code>oas:DeletePriceListItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeletePriceListItemResponse|error`

**Sample code:**

```ballerina
oas:DeletePriceListItemResponse result = check pricefxClient->deletePriceListItems(id, payload);
```

</div>
</details>

<details>
<summary>deletePriceListType</summary>

<div>

Delete a Price List Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeletePLTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:PriceListTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:PriceListTypeOperationEnvelope result = check pricefxClient->deletePriceListType(payload);
```

</div>
</details>

<details>
<summary>getPriceList</summary>

<div>

Get a Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List you want to retrieve details for. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetPriceListResponse|error`

**Sample code:**

```ballerina
oas:GetPriceListResponse result = check pricefxClient->getPriceList(id);
```

</div>
</details>

<details>
<summary>listPriceListItems</summary>

<div>

List Price List Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List you want to retrieve items for. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `payload` | <code>oas:ListPriceListItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricelistitemResponse|error`

**Sample code:**

```ballerina
oas:pricelistitemResponse result = check pricefxClient->listPriceListItems(id, payload);
```

</div>
</details>

<details>
<summary>listPriceListTypes</summary>

<div>

List Price List Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListPriceListTypesEnvelope|error`

**Sample code:**

```ballerina
oas:ListPriceListTypesEnvelope result = check pricefxClient->listPriceListTypes();
```

</div>
</details>

<details>
<summary>listPriceLists</summary>

<div>

List Price Lists

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListPriceListsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListPriceListsResponse|error`

**Sample code:**

```ballerina
oas:ListPriceListsResponse result = check pricefxClient->listPriceLists(payload);
```

</div>
</details>

<details>
<summary>revokePriceList</summary>

<div>

Revoke a Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes |  |
| `payload` | <code>oas:PricelistmanagerSubmitidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricelistitemResponse|error`

**Sample code:**

```ballerina
oas:pricelistitemResponse result = check pricefxClient->revokePriceList(id, payload);
```

</div>
</details>

<details>
<summary>submitPriceList</summary>

<div>

Submit a Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List you want to submit. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `payload` | <code>oas:PricelistmanagerSubmitidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricelistitemResponse|error`

**Sample code:**

```ballerina
oas:pricelistitemResponse result = check pricefxClient->submitPriceList(id, payload);
```

</div>
</details>

<details>
<summary>updatePriceListDetail</summary>

<div>

Update a Pricelist Detail

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price List whose Item you want to update. The `id` is the `typedId` without the suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `payload` | <code>oas:UpdatePricelistDetailRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdatePricelistDetailResponse|error`

**Sample code:**

```ballerina
oas:UpdatePricelistDetailResponse result = check pricefxClient->updatePriceListDetail(id, payload);
```

</div>
</details>

<details>
<summary>updatePriceListType</summary>

<div>

Update a Price List Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdatePLTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:PriceListTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:PriceListTypeOperationEnvelope result = check pricefxClient->updatePriceListType(payload);
```

</div>
</details>

#### Manual Price Lists

<details>
<summary>addManualPriceListProducts</summary>

<div>

Add Products to a Manual Pricelist

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List where you want to add products to |
| `payload` | <code>oas:AddProductsToManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->addManualPriceListProducts(id, payload);
```

</div>
</details>

<details>
<summary>addManualPriceListProductsNoRecalc</summary>

<div>

Add Products to a Manual Price List (No Recalculation)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List where you want to add products to |
| `payload` | <code>oas:AddProductsToManualPriceListNoRecalcRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddProductsToManualPriceListNoRecalcResponse|error`

**Sample code:**

```ballerina
oas:AddProductsToManualPriceListNoRecalcResponse result = check pricefxClient->addManualPriceListProductsNoRecalc(id, payload);
```

</div>
</details>

<details>
<summary>calculateManualPriceList</summary>

<div>

Calculate a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List you want to start the calculation for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateManualPriceListResponse|error`

**Sample code:**

```ballerina
oas:CalculateManualPriceListResponse result = check pricefxClient->calculateManualPriceList(id);
```

</div>
</details>

<details>
<summary>copyManualPriceList</summary>

<div>

Copy a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List you want to copy |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:manualpricelistResponse|error`

**Sample code:**

```ballerina
oas:manualpricelistResponse result = check pricefxClient->copyManualPriceList(id);
```

</div>
</details>

<details>
<summary>createManualPriceList</summary>

<div>

Create a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CreateManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:manualpricelistResponse|error`

**Sample code:**

```ballerina
oas:manualpricelistResponse result = check pricefxClient->createManualPriceList(payload);
```

</div>
</details>

<details>
<summary>deleteManualPriceList</summary>

<div>

Delete a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:manualpricelistResponse|error`

**Sample code:**

```ballerina
oas:manualpricelistResponse result = check pricefxClient->deleteManualPriceList(payload);
```

</div>
</details>

<details>
<summary>deleteManualPriceListProduct</summary>

<div>

Delete a Product from a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List whose product you want to delete |
| `payload` | <code>oas:DeleteProductFromManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->deleteManualPriceListProduct(id, payload);
```

</div>
</details>

<details>
<summary>deleteManualPriceListProducts</summary>

<div>

Delete Products from a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List whose products you want to delete |
| `payload` | <code>oas:DeleteProductsFromManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteProductsFromManualPriceListResponse|error`

**Sample code:**

```ballerina
oas:DeleteProductsFromManualPriceListResponse result = check pricefxClient->deleteManualPriceListProducts(id, payload);
```

</div>
</details>

<details>
<summary>listManualPriceListProducts</summary>

<div>

List Products From a Manual Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List you want to retrieve products from |
| `payload` | <code>oas:ListProductsFromManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListProductsFromManualPriceListResponse|error`

**Sample code:**

```ballerina
oas:ListProductsFromManualPriceListResponse result = check pricefxClient->listManualPriceListProducts(id, payload);
```

</div>
</details>

<details>
<summary>listManualPriceLists</summary>

<div>

List Manual Price Lists

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListManualPriceListsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:manualpricelistResponse|error`

**Sample code:**

```ballerina
oas:manualpricelistResponse result = check pricefxClient->listManualPriceLists(payload);
```

</div>
</details>

<details>
<summary>massEditManualPriceListItems</summary>

<div>

Mass Edit a Manual Price List Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List whose products you want to update |
| `payload` | <code>oas:MassEditMPLRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassEditManualPriceListResponse|error`

**Sample code:**

```ballerina
oas:MassEditManualPriceListResponse result = check pricefxClient->massEditManualPriceListItems(id, payload);
```

</div>
</details>

<details>
<summary>updateManualPriceListItem</summary>

<div>

Update a Manual Price List Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List whose item you want to update |
| `payload` | <code>oas:UpdateManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateManualPriceListResponse|error`

**Sample code:**

```ballerina
oas:UpdateManualPriceListResponse result = check pricefxClient->updateManualPriceListItem(id, payload);
```

</div>
</details>

<details>
<summary>upsertManualPriceListProduct</summary>

<div>

Upsert a Product in a Manual Price List + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Manual Price List whose product you want to create or update |
| `payload` | <code>oas:UpsertProductManualPriceListRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->upsertManualPriceListProduct(id, payload);
```

</div>
</details>

#### Calculation Grids

<details>
<summary>acceptCalculationGridItem</summary>

<div>

Submit a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Calculation Grid you want to submit items for. You can retrieve the `id` of the CG, for example, by calling the `/fetch/CG` endpoint |
| `payload` | <code>oas:SubmitCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:SubmitCalculationGridItemResponse result = check pricefxClient->acceptCalculationGridItem(id, payload);
```

</div>
</details>

<details>
<summary>addCalculationGrid</summary>

<div>

Add a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:AddCalculationGridResponse result = check pricefxClient->addCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>addCalculationGridItem</summary>

<div>

Add a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:AddCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:AddCalculationGridItemResponse result = check pricefxClient->addCalculationGridItem(keyNumber, payload);
```

</div>
</details>

<details>
<summary>calculateCalculationGrid</summary>

<div>

Calculate a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid you want to calculate |
| `payload` | <code>oas:CalculateCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:CalculateCalculationGridResponse result = check pricefxClient->calculateCalculationGrid(id, payload);
```

</div>
</details>

<details>
<summary>deleteCalculationGrid</summary>

<div>

Delete a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:DeleteCalculationGridResponse result = check pricefxClient->deleteCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>deleteCalculationGridItem</summary>

<div>

Delete a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:DeleteCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:DeleteCalculationGridItemResponse result = check pricefxClient->deleteCalculationGridItem(keyNumber, payload);
```

</div>
</details>

<details>
<summary>getCalculationGrid</summary>

<div>

Get a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | ID of the Calculation Grid you want to retrieve |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:GetCalculationGridResponse result = check pricefxClient->getCalculationGrid(id, payload);
```

</div>
</details>

<details>
<summary>getCalculationGridItem</summary>

<div>

Get a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid Item you want to fetch |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:GetCalculationGridItemResponse result = check pricefxClient->getCalculationGridItem(keyNumber, id, payload);
```

</div>
</details>

<details>
<summary>listCalculationGridItems</summary>

<div>

List Calculation Grid Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:ListCalculationGridItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculationGridItemsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculationGridItemsResponse result = check pricefxClient->listCalculationGridItems(keyNumber, payload);
```

</div>
</details>

<details>
<summary>listCalculationGrids</summary>

<div>

List Calculation Grids

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculationGridsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculationGridsResponse result = check pricefxClient->listCalculationGrids(payload);
```

</div>
</details>

<details>
<summary>rejectCalculationGridItem</summary>

<div>

Deny a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Calculation Grid you want to deny items for. You can retrieve the `id` of the CG, for example, by calling the `/fetch/CG` endpoint |
| `payload` | <code>oas:DenyCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DenyCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:DenyCalculationGridItemResponse result = check pricefxClient->rejectCalculationGridItem(id, payload);
```

</div>
</details>

<details>
<summary>updateCalculationGrid</summary>

<div>

Update a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:UpdateCalculationGridResponse result = check pricefxClient->updateCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>updateCalculationGridItem</summary>

<div>

Update a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid Item you want to update |
| `payload` | <code>oas:UpdateCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:UpdateCalculationGridItemResponse result = check pricefxClient->updateCalculationGridItem(id, payload);
```

</div>
</details>

#### Calculated Field Sets

<details>
<summary>calculateCfs</summary>

<div>

Calculate a CFS

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` is the `typedId` without the type suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateCFSResponse|error`

**Sample code:**

```ballerina
oas:CalculateCFSResponse result = check pricefxClient->calculateCfs(id);
```

</div>
</details>

<details>
<summary>cancelCfsCalculation</summary>

<div>

Cancel a CFS Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` is the `typedId` without the type suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.PL**  is **2147484837** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->cancelCfsCalculation(id);
```

</div>
</details>

<details>
<summary>deleteCalculatedFieldSet</summary>

<div>

Delete a Calculated Field Set

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCalculatedFieldSetRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->deleteCalculatedFieldSet(payload);
```

</div>
</details>

<details>
<summary>listCalculatedFieldSets</summary>

<div>

List Calculated Field Sets

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculatedFieldSetsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculatedFieldSetsResponse result = check pricefxClient->listCalculatedFieldSets();
```

</div>
</details>

#### Live Price Grids

<details>
<summary>addLivePriceGridType</summary>

<div>

Add a Live Price Grid Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddPGTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:LivePriceGridTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:LivePriceGridTypeOperationEnvelope result = check pricefxClient->addLivePriceGridType(payload);
```

</div>
</details>

<details>
<summary>addPriceGridItemsToPriceGrid</summary>

<div>

Add Price Grid Items to a Price Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Live Price Grid where you want to add Price Grid Items to. `id`  is the `typedId` without **PG** suffix. For example, the `id` attribute of the item with `typedId` = **649.PG** is **649**. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:AddPriceGridItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddPriceGridItemsToPriceGridResponse|error`

**Sample code:**

```ballerina
oas:AddPriceGridItemsToPriceGridResponse result = check pricefxClient->addPriceGridItemsToPriceGrid(id, payload);
```

</div>
</details>

<details>
<summary>calculatePriceGrid</summary>

<div>

Calculate a Price Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculatePriceGridResponse|error`

**Sample code:**

```ballerina
oas:CalculatePriceGridResponse result = check pricefxClient->calculatePriceGrid(id);
```

</div>
</details>

<details>
<summary>cancelPriceGridCalculation</summary>

<div>

Cancel a Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Live Price Grid whose running calculation should be cancelled |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CancelCalculationResponse|error`

**Sample code:**

```ballerina
oas:CancelCalculationResponse result = check pricefxClient->cancelPriceGridCalculation(id);
```

</div>
</details>

<details>
<summary>convertToPriceList</summary>

<div>

Convert to Price List

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConvertPriceListResponse|error`

**Sample code:**

```ballerina
oas:ConvertPriceListResponse result = check pricefxClient->convertToPriceList(id);
```

</div>
</details>

<details>
<summary>copyPriceGrid</summary>

<div>

Copy a Price Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Live Price Grid you want to copy. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyPriceGridResponse|error`

**Sample code:**

```ballerina
oas:CopyPriceGridResponse result = check pricefxClient->copyPriceGrid(id);
```

</div>
</details>

<details>
<summary>countMassActionItems</summary>

<div>

Count Mass Action Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes |  |
| `payload` | <code>oas:CountMassActionItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CountMassActionItemsResponse|error`

**Sample code:**

```ballerina
oas:CountMassActionItemsResponse result = check pricefxClient->countMassActionItems(id, payload);
```

</div>
</details>

<details>
<summary>deleteLivePriceGrid</summary>

<div>

Delete a Live Price Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteLivePriceGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteLivePriceGridResponse|error`

**Sample code:**

```ballerina
oas:DeleteLivePriceGridResponse result = check pricefxClient->deleteLivePriceGrid(payload);
```

</div>
</details>

<details>
<summary>deleteLivePriceGridType</summary>

<div>

Delete a Live Price Grid Type + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeletePLTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:LivePriceGridTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:LivePriceGridTypeOperationEnvelope result = check pricefxClient->deleteLivePriceGridType(payload);
```

</div>
</details>

<details>
<summary>deletePriceGridItem</summary>

<div>

Delete a Price Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid you want to delete the Price Grid Item from |
| `payload` | <code>oas:DeletePriceGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricegriditemResponse|error`

**Sample code:**

```ballerina
oas:pricegriditemResponse result = check pricefxClient->deletePriceGridItem(id, payload);
```

</div>
</details>

<details>
<summary>deletePriceGridItemFilter</summary>

<div>

Delete a Price Grid Item (Filter) + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid that contains Price Grid Items you want to delete |
| `payload` | <code>oas:DeletePriceGridItemFilterRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->deletePriceGridItemFilter(id, payload);
```

</div>
</details>

<details>
<summary>denyLivePriceGridItem</summary>

<div>

Deny a Live Price Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid that contains the Price Grid Item you want to deny |
| `payload` | <code>oas:DenyLivePriceGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricegriditemResponse|error`

**Sample code:**

```ballerina
oas:pricegriditemResponse result = check pricefxClient->denyLivePriceGridItem(id, payload);
```

</div>
</details>

<details>
<summary>downloadLivePriceGridExcelFile</summary>

<div>

Download a Live Price Grid Excel File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id1` | <code>string</code> | Yes |  |
| `id2` | <code>string</code> | Yes |  |
| `id3` | <code>string</code> | Yes |  |
| `id4` | <code>string</code> | Yes |  |
| `id5` | <code>string</code> | Yes |  |
| `id6` | <code>string</code> | Yes |  |
| `id7` | <code>string</code> | Yes |  |
| `id8` | <code>string</code> | Yes |  |
| `id9` | <code>string</code> | Yes |  |
| `id10` | <code>string</code> | Yes |  |
| `id11` | <code>string</code> | Yes |  |
| `id12` | <code>string</code> | Yes |  |
| `id13` | <code>string</code> | Yes | IDs of the Price Grids you want to download |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:DownloadLivePriceGridExcelFileQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->downloadLivePriceGridExcelFile(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10, id11, id12, id13, queries);
```

</div>
</details>

<details>
<summary>getLivePriceGrid</summary>

<div>

Get a Live Price Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Live Price Grid you want to retrieve details for. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetLivePriceGridResponse|error`

**Sample code:**

```ballerina
oas:GetLivePriceGridResponse result = check pricefxClient->getLivePriceGrid(id);
```

</div>
</details>

<details>
<summary>listLivePriceGridItems</summary>

<div>

List Live Price Grid Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Live Price Grid you want to retrieve items for. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:ListLivePriceGridItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLivePriceGridItemsResponse|error`

**Sample code:**

```ballerina
oas:ListLivePriceGridItemsResponse result = check pricefxClient->listLivePriceGridItems(id, payload);
```

</div>
</details>

<details>
<summary>listLivePriceGridTypes</summary>

<div>

List Live Price Grid Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLivePriceGridTypesEnvelope|error`

**Sample code:**

```ballerina
oas:ListLivePriceGridTypesEnvelope result = check pricefxClient->listLivePriceGridTypes();
```

</div>
</details>

<details>
<summary>listLivePriceGrids</summary>

<div>

List Live Price Grids

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListLivePriceGridsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLivePriceGridsResponse|error`

**Sample code:**

```ballerina
oas:ListLivePriceGridsResponse result = check pricefxClient->listLivePriceGrids(payload);
```

</div>
</details>

<details>
<summary>massEditPriceGridItems</summary>

<div>

Mass Edit Price Grid Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Live Price Grid whose items you want to edit. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:MassEditPriceGridItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassEditPriceGridItemsResponse|error`

**Sample code:**

```ballerina
oas:MassEditPriceGridItemsResponse result = check pricefxClient->massEditPriceGridItems(id, payload);
```

</div>
</details>

<details>
<summary>performMassAction</summary>

<div>

Perform a Mass Action

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid that contains items you want to apply workflow actions to |
| `payload` | <code>oas:PerformMassActionRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:PerformMassActionResponse|error`

**Sample code:**

```ballerina
oas:PerformMassActionResponse result = check pricefxClient->performMassAction(id, payload);
```

</div>
</details>

<details>
<summary>submitProducts</summary>

<div>

Submit Products

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Live Price Grid you want to submit items for. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:SubmitProductsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitProductsResponse|error`

**Sample code:**

```ballerina
oas:SubmitProductsResponse result = check pricefxClient->submitProducts(id, payload);
```

</div>
</details>

<details>
<summary>updateLivePriceGridItem</summary>

<div>

Update a Live Price Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid whose item you want to update. `id`  is the `typedId` without **PG** suffix. For example, the `id` attribute of the item with `typedId` = **649.PG** is **649**. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:UpdateLivePriceGridItemRequest</code> | Yes | We have performed an update action on the `comments` field in our request sample &gt;&gt;&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricegriditemResponse|error`

**Sample code:**

```ballerina
oas:pricegriditemResponse result = check pricefxClient->updateLivePriceGridItem(id, payload);
```

</div>
</details>

<details>
<summary>updateLivePriceGridItemNo</summary>

<div>

Update a Live Price Grid Item (No Recalculation)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the Price Grid whose item you want to update. `id`  is the `typedId` without **PG** suffix. For example, the `id` attribute of the item with `typedId` = **649.PG** is **649**. You can retrieve the `id` of the LPG, for example, by calling the `/fetch/PG` endpoint |
| `payload` | <code>oas:UpdateLivePriceGridItemNoRecalcRequest</code> | Yes | We have performed an update action on the `comments` field in our request sample &gt;&gt;&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:pricegriditemResponse|error`

**Sample code:**

```ballerina
oas:pricegriditemResponse result = check pricefxClient->updateLivePriceGridItemNo(id, payload);
```

</div>
</details>

<details>
<summary>updateLivePriceGridType</summary>

<div>

Update a Live Price Grid Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdatePGTTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:LivePriceGridTypeOperationEnvelope|error`

**Sample code:**

```ballerina
oas:LivePriceGridTypeOperationEnvelope result = check pricefxClient->updateLivePriceGridType(payload);
```

</div>
</details>

#### Quotes

<details>
<summary>addQuoteProducts</summary>

<div>

Add Products to a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddProductsToQuoteRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->addQuoteProducts(payload);
```

</div>
</details>

<details>
<summary>convertQuoteToDeal</summary>

<div>

Convert to a Deal

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `identifier` | <code>string</code> | Yes | Can be either the `uniqueName` or the `typedId` |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->convertQuoteToDeal(identifier);
```

</div>
</details>

<details>
<summary>copyQuote</summary>

<div>

Copy a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyQuoteEnvelope|error`

**Sample code:**

```ballerina
oas:CopyQuoteEnvelope result = check pricefxClient->copyQuote(typedId, payload);
```

</div>
</details>

<details>
<summary>createClic</summary>

<div>

Create a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"Q"&#124;"QTMP"</code> | Yes | Enter the type code of the entity you want to create |
| `payload` | <code>oas:ClicmanagerCreateTypeCodeBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ClicOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ClicOperationEnvelope result = check pricefxClient->createClic(typeCode, payload);
```

</div>
</details>

<details>
<summary>createQuoteRevision</summary>

<div>

Create a New Revision

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `identifier` | <code>string</code> | Yes | Can be either the `uniqueName` or the `typedId` |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->createQuoteRevision(identifier);
```

</div>
</details>

<details>
<summary>exportQuoteDocx</summary>

<div>

Export a DOCX File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | Specify the `uniqueName` of the quote you want to download |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportQuoteDocxQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->exportQuoteDocx(uniqueName, queries);
```

</div>
</details>

<details>
<summary>exportQuoteExcel</summary>

<div>

Export an Excel File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | Specify the `uniqueName` of the quote you want to download |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportQuoteExcelQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->exportQuoteExcel(uniqueName, queries);
```

</div>
</details>

<details>
<summary>exportQuotePdf</summary>

<div>

Export a PDF File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | Specify the `uniqueName` of the quote you want to download |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportQuotePdfQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `record`

**Sample code:**

```ballerina
record result = check pricefxClient->exportQuotePdf(uniqueName, queries);
```

</div>
</details>

<details>
<summary>getClicDraftHeader</summary>

<div>

Get a Temporary Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Quote you want to retrieve the temporary data from |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ClicDraftHeaderEnvelope|error`

**Sample code:**

```ballerina
oas:ClicDraftHeaderEnvelope result = check pricefxClient->getClicDraftHeader(typedId, payload);
```

</div>
</details>

<details>
<summary>getClicFolderStats</summary>

<div>

Get Folder Statistics

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the document whose folder statistics you want to fetch |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:GetClicFolderStatsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ClicFolderStatsEnvelope|error`

**Sample code:**

```ballerina
oas:ClicFolderStatsEnvelope result = check pricefxClient->getClicFolderStats(typedId, queries);
```

</div>
</details>

<details>
<summary>getQuote</summary>

<div>

Get a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedID` | <code>string</code> | Yes | Enter the quote typed ID. You get the `typedId` in the response when fetching all quotes using the `/quotemanager.fetchlist` endpoint |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->getQuote(typedID);
```

</div>
</details>

<details>
<summary>listQuoteProducts</summary>

<div>

List Products

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListProductsRequest1</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->listQuoteProducts(payload);
```

</div>
</details>

<details>
<summary>listQuotes</summary>

<div>

List Quotes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListQuotesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListQuotesResponse|error`

**Sample code:**

```ballerina
oas:ListQuotesResponse result = check pricefxClient->listQuotes(payload);
```

</div>
</details>

<details>
<summary>markQuoteLost</summary>

<div>

Mark an Offer as Lost

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `identifier` | <code>string</code> | Yes | Can be either the `uniqueName` or the `typedId` |
| `payload` | <code>oas:MarkOfferAsLostRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->markQuoteLost(identifier, payload);
```

</div>
</details>

<details>
<summary>recalculateQuote</summary>

<div>

Recalculate a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:RecalculateQuoteRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->recalculateQuote(payload);
```

</div>
</details>

<details>
<summary>revokeQuote</summary>

<div>

Revoke a Deal

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `identifier` | <code>string</code> | Yes | Can be either the `uniqueName` or the `typedId` |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RevokeDealResponse|error`

**Sample code:**

```ballerina
oas:RevokeDealResponse result = check pricefxClient->revokeQuote(identifier);
```

</div>
</details>

<details>
<summary>saveClicDraft</summary>

<div>

Save a Temporary Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Temporary Quote you want to save |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ClicOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ClicOperationEnvelope result = check pricefxClient->saveClicDraft(typedId, payload);
```

</div>
</details>

<details>
<summary>submitQuote</summary>

<div>

Submit a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SubmitQuoteRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->submitQuote(payload);
```

</div>
</details>

<details>
<summary>undoRevokeQuote</summary>

<div>

Undo Quote Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoRevokeQuote(typedId);
```

</div>
</details>

<details>
<summary>upsertQuote</summary>

<div>

Upsert a Quote

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertQuoteRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:quoteResponse|error`

**Sample code:**

```ballerina
oas:quoteResponse result = check pricefxClient->upsertQuote(payload);
```

</div>
</details>

#### Contracts (Agreements & Promotions)

<details>
<summary>addContractLineItems</summary>

<div>

Add Contract Line Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddContractLineItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:contractModelResponse|error`

**Sample code:**

```ballerina
oas:contractModelResponse result = check pricefxClient->addContractLineItems(payload);
```

</div>
</details>

<details>
<summary>exportContractPdf</summary>

<div>

Export a PDF File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | Specify the `uniqueName` of the A&P you want to download |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->exportContractPdf(uniqueName);
```

</div>
</details>

<details>
<summary>getContract</summary>

<div>

Get a Contract

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | `uniqueName` of the Contract you want to retrieve details for. Alternatively, `typedId` can be also used |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:contractModelResponse|error`

**Sample code:**

```ballerina
oas:contractModelResponse result = check pricefxClient->getContract(uniqueName);
```

</div>
</details>

<details>
<summary>listContractCalculations</summary>

<div>

List Contract Calculations

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListContractCalculationsEnvelope|error`

**Sample code:**

```ballerina
oas:ListContractCalculationsEnvelope result = check pricefxClient->listContractCalculations(payload);
```

</div>
</details>

<details>
<summary>listContractPriceRecords</summary>

<div>

List Contract Price Records

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:FetchCPRBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListContractPriceRecords|error`

**Sample code:**

```ballerina
oas:ListContractPriceRecords result = check pricefxClient->listContractPriceRecords(payload);
```

</div>
</details>

<details>
<summary>listContracts</summary>

<div>

List Contracts

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListContractsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:contractResponse|error`

**Sample code:**

```ballerina
oas:contractResponse result = check pricefxClient->listContracts(payload);
```

</div>
</details>

<details>
<summary>submitContract</summary>

<div>

Submit a Contract

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SubmitContractRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:contractModelResponse|error`

**Sample code:**

```ballerina
oas:contractModelResponse result = check pricefxClient->submitContract(payload);
```

</div>
</details>

<details>
<summary>undoRevokeContract</summary>

<div>

Undo Agreement & Promotion Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoRevokeContract(typedId);
```

</div>
</details>

<details>
<summary>upsertContract</summary>

<div>

Upsert a Contract

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertContractRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:contractModelResponse|error`

**Sample code:**

```ballerina
oas:contractModelResponse result = check pricefxClient->upsertContract(payload);
```

</div>
</details>

#### Rebate Agreements

<details>
<summary>addRebateAgreementItems</summary>

<div>

Add Rebate Agreement Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:GetCustomerRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:rebateagreementResponse|error`

**Sample code:**

```ballerina
oas:rebateagreementResponse result = check pricefxClient->addRebateAgreementItems(payload);
```

</div>
</details>

<details>
<summary>deleteRebateAgreement</summary>

<div>

Delete a Rebate Agreement

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteRebateAgreementRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:rebateagreementResponse|error`

**Sample code:**

```ballerina
oas:rebateagreementResponse result = check pricefxClient->deleteRebateAgreement(payload);
```

</div>
</details>

<details>
<summary>getRebateAgreement</summary>

<div>

Get a Rebate Agreement

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The `uniqueName` of the Rebate Agreement you want to retrieve details for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:rebateagreementResponse|error`

**Sample code:**

```ballerina
oas:rebateagreementResponse result = check pricefxClient->getRebateAgreement(uniqueName);
```

</div>
</details>

<details>
<summary>listRebateAgreementItems</summary>

<div>

List Rebate Agreement Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListRebateAgreementItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRebateAgreementItemsResponse|error`

**Sample code:**

```ballerina
oas:ListRebateAgreementItemsResponse result = check pricefxClient->listRebateAgreementItems(payload);
```

</div>
</details>

<details>
<summary>listRebateAgreements</summary>

<div>

List Rebate Agreements

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListRebateAgreementsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRebateAgreementsResponse|error`

**Sample code:**

```ballerina
oas:ListRebateAgreementsResponse result = check pricefxClient->listRebateAgreements(payload);
```

</div>
</details>

<details>
<summary>undoRebateAgreementRevocation</summary>

<div>

Undo Rebate Agreement Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoRebateAgreementRevocation(typedId);
```

</div>
</details>

<details>
<summary>undoRebateRecordRevocation</summary>

<div>

Undo Rebate Record Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoRebateRecordRevocation(typedId);
```

</div>
</details>

<details>
<summary>upsertRebateAgreement</summary>

<div>

Upsert a Rebate Agreement

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertRebateAgreementRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:rebateagreementResponse|error`

**Sample code:**

```ballerina
oas:rebateagreementResponse result = check pricefxClient->upsertRebateAgreement(payload);
```

</div>
</details>

#### Rebate Calculations

<details>
<summary>addRebateCalculation</summary>

<div>

Add a Rebate Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddRRSCBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddRebateCalculationResponse|error`

**Sample code:**

```ballerina
oas:AddRebateCalculationResponse result = check pricefxClient->addRebateCalculation(payload);
```

</div>
</details>

<details>
<summary>deleteRebateCalculation</summary>

<div>

Delete a Rebate Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteRebateCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteRebateCalculationResponse|error`

**Sample code:**

```ballerina
oas:DeleteRebateCalculationResponse result = check pricefxClient->deleteRebateCalculation(payload);
```

</div>
</details>

<details>
<summary>listRebateCalculations</summary>

<div>

List Rebate Calculations

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:FetchRRSCBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRebateCalculationsResponse|error`

**Sample code:**

```ballerina
oas:ListRebateCalculationsResponse result = check pricefxClient->listRebateCalculations(payload);
```

</div>
</details>

<details>
<summary>runRebateCalculation</summary>

<div>

Run a Rebate Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:RebaterecordCalculatesetBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RunRebateCalculationResponse|error`

**Sample code:**

```ballerina
oas:RunRebateCalculationResponse result = check pricefxClient->runRebateCalculation(payload);
```

</div>
</details>

<details>
<summary>saveRebateCalculation</summary>

<div>

Save a Rebate Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SaveRebateCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveRebateCalculationResponse|error`

**Sample code:**

```ballerina
oas:SaveRebateCalculationResponse result = check pricefxClient->saveRebateCalculation(payload);
```

</div>
</details>

#### Rebate Record Group

<details>
<summary>calculateRebateRecordGroup</summary>

<div>

Calculate a Rebate Record Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Rebate Record Group you want to calculate |
| `payload` | <code>oas:RebaterecordgroupCalculatetypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateRebateRecordGroupEnvelope|error`

**Sample code:**

```ballerina
oas:CalculateRebateRecordGroupEnvelope result = check pricefxClient->calculateRebateRecordGroup(typedId, payload);
```

</div>
</details>

<details>
<summary>getRebateRecordGroup</summary>

<div>

Get a Rebate Record Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->getRebateRecordGroup(payload);
```

</div>
</details>

<details>
<summary>massSubmitRebateRecordGroupItems</summary>

<div>

Mass Submit Rebate Record Groups

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:RebaterecordgroupMasssubmittypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassSubmitRRGResponse|error`

**Sample code:**

```ballerina
oas:MassSubmitRRGResponse result = check pricefxClient->massSubmitRebateRecordGroupItems(typedId, payload);
```

</div>
</details>

<details>
<summary>massSubmitRebateRecordGroups</summary>

<div>

Mass Submit Rebate Record Groups

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:RebaterecordgroupMasssubmittypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassSubmitRebateRecordGroupsEnvelope|error`

**Sample code:**

```ballerina
oas:MassSubmitRebateRecordGroupsEnvelope result = check pricefxClient->massSubmitRebateRecordGroups(payload);
```

</div>
</details>

<details>
<summary>previewRebateRecordGroupWorkflow</summary>

<div>

Preview a Rebate Record Group Workflow

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:RebaterecordgroupPreviewtypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RebateRecordGroupWorkflowEnvelope|error`

**Sample code:**

```ballerina
oas:RebateRecordGroupWorkflowEnvelope result = check pricefxClient->previewRebateRecordGroupWorkflow(typedId, payload);
```

</div>
</details>

<details>
<summary>revokeRebateRecordGroup</summary>

<div>

Revoke a Rebate Record Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Rebate Record Group you want to revoke |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RevokeRebateRecordGroupEnvelope|error`

**Sample code:**

```ballerina
oas:RevokeRebateRecordGroupEnvelope result = check pricefxClient->revokeRebateRecordGroup(typedId);
```

</div>
</details>

<details>
<summary>shouldSubmitRrgAsynchronously</summary>

<div>

Should Submit a RRG Asynchronously

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Rebate Record Group you want to return the async threshold boolean for |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CheckFileExistsEnvelope|error`

**Sample code:**

```ballerina
oas:CheckFileExistsEnvelope result = check pricefxClient->shouldSubmitRrgAsynchronously(typedId, payload);
```

</div>
</details>

<details>
<summary>submitRebateRecordGroup</summary>

<div>

Submit a Rebate Record Group

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Rebate Record Group you want to submit |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitRebateRecordGroup|error`

**Sample code:**

```ballerina
oas:SubmitRebateRecordGroup result = check pricefxClient->submitRebateRecordGroup(typedId, payload);
```

</div>
</details>

<details>
<summary>undoRebateRecordGroupRevocation</summary>

<div>

Undo Rebate Record Group Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoRebateRecordGroupRevocation(typedId);
```

</div>
</details>

#### Sales Compensations

<details>
<summary>addCalculation</summary>

<div>

Add a Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCalculationResponse|error`

**Sample code:**

```ballerina
oas:AddCalculationResponse result = check pricefxClient->addCalculation(payload);
```

</div>
</details>

<details>
<summary>addCompensationType</summary>

<div>

Add a Compensation Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCompensationTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCompensationTypeEnvelope|error`

**Sample code:**

```ballerina
oas:AddCompensationTypeEnvelope result = check pricefxClient->addCompensationType(payload);
```

</div>
</details>

<details>
<summary>addConditionType</summary>

<div>

Add a Condition Type + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddConditionTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddConditionTypeEnvelope|error`

**Sample code:**

```ballerina
oas:AddConditionTypeEnvelope result = check pricefxClient->addConditionType(payload);
```

</div>
</details>

<details>
<summary>deleteCalculation</summary>

<div>

Delete a Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCalculationResponse|error`

**Sample code:**

```ballerina
oas:DeleteCalculationResponse result = check pricefxClient->deleteCalculation(payload);
```

</div>
</details>

<details>
<summary>deleteCompensationPlan</summary>

<div>

Delete a Compensation Plan

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCompensationPlanRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCompensationPlanResponse|error`

**Sample code:**

```ballerina
oas:DeleteCompensationPlanResponse result = check pricefxClient->deleteCompensationPlan(payload);
```

</div>
</details>

<details>
<summary>deleteCompensationType</summary>

<div>

Delete a Compensation Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCOHTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCompensationTypeEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteCompensationTypeEnvelope result = check pricefxClient->deleteCompensationType(payload);
```

</div>
</details>

<details>
<summary>deleteConditionType</summary>

<div>

Delete a Condition Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteConditionTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteConditionTypeEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteConditionTypeEnvelope result = check pricefxClient->deleteConditionType(payload);
```

</div>
</details>

<details>
<summary>duplicateCompensationPlan</summary>

<div>

Duplicate a Compensation Plan

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Compensation Plan you want to duplicate |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DuplicateCompensationPlanEnvelope|error`

**Sample code:**

```ballerina
oas:DuplicateCompensationPlanEnvelope result = check pricefxClient->duplicateCompensationPlan(typedId);
```

</div>
</details>

<details>
<summary>getSignatureStatus</summary>

<div>

Get a Signature Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Compensation document you want to retrieve the signature status for |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetSignatureStatusResponse|error`

**Sample code:**

```ballerina
oas:GetSignatureStatusResponse result = check pricefxClient->getSignatureStatus(typedId, payload);
```

</div>
</details>

<details>
<summary>getSignedDocument</summary>

<div>

Get a Signed Document

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | A `uniqueName` of the Compensation Plan you want to download a signed file for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->getSignedDocument(uniqueName);
```

</div>
</details>

<details>
<summary>listAccrualRecords</summary>

<div>

List Accrual Records

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListAccrualRecordsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListAccrualRecordsResponse|error`

**Sample code:**

```ballerina
oas:ListAccrualRecordsResponse result = check pricefxClient->listAccrualRecords(payload);
```

</div>
</details>

<details>
<summary>listCalculations</summary>

<div>

List Calculations

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCalculationsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculationsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculationsResponse result = check pricefxClient->listCalculations(payload);
```

</div>
</details>

<details>
<summary>listCompensationPlans</summary>

<div>

List Compensation Plans

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCompensationPlansRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCompensationPlansResponse|error`

**Sample code:**

```ballerina
oas:ListCompensationPlansResponse result = check pricefxClient->listCompensationPlans(payload);
```

</div>
</details>

<details>
<summary>listCompensationRecords</summary>

<div>

List Compensation Records

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `compensationRecordSetId` | <code>string</code> | Yes | ID of the CompensationRecordSet into which this Compensation Record belongs. By default it belongs to "Default" CompensationRecordSet, but you can change it when you create the Compensation Record. This can be useful if you create different "kinds" of Compensation Records which will be used to calculate different results at different times |
| `payload` | <code>oas:ListCompensationRecordsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCompensationRecordsResponse|error`

**Sample code:**

```ballerina
oas:ListCompensationRecordsResponse result = check pricefxClient->listCompensationRecords(compensationRecordSetId, payload);
```

</div>
</details>

<details>
<summary>listCompensationTypes</summary>

<div>

List Compensation Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCompensationTypesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCompensationTypesEnvelope|error`

**Sample code:**

```ballerina
oas:ListCompensationTypesEnvelope result = check pricefxClient->listCompensationTypes(payload);
```

</div>
</details>

<details>
<summary>listConditionTypes</summary>

<div>

List Condition Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListConditionTypesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListConditionTypesEnvelope|error`

**Sample code:**

```ballerina
oas:ListConditionTypesEnvelope result = check pricefxClient->listConditionTypes(payload);
```

</div>
</details>

<details>
<summary>recalculateQuoteContractRebate</summary>

<div>

Recalculate a Quote/Contract/Rebate Agreement/Compensation Plan

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the document you want to calculate |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:RecalculateQuoteContractRebateQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:RecalculateClicEnvelope|error`

**Sample code:**

```ballerina
oas:RecalculateClicEnvelope result = check pricefxClient->recalculateQuoteContractRebate(typedId, queries);
```

</div>
</details>

<details>
<summary>revokeCompensationRecord</summary>

<div>

Revoke a Compensation Record

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Compensation Record you want to revoke |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->revokeCompensationRecord(typedId);
```

</div>
</details>

<details>
<summary>runCalculation</summary>

<div>

Run a Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:RunCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RunCalculationResponse|error`

**Sample code:**

```ballerina
oas:RunCalculationResponse result = check pricefxClient->runCalculation(payload);
```

</div>
</details>

<details>
<summary>saveCalculation</summary>

<div>

Save Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SaveCalculationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveCalculationResponse|error`

**Sample code:**

```ballerina
oas:SaveCalculationResponse result = check pricefxClient->saveCalculation(payload);
```

</div>
</details>

<details>
<summary>saveCompensationRecord</summary>

<div>

Save a Compensation Record

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SaveCompensationRecordRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveCompensationRecordResponse|error`

**Sample code:**

```ballerina
oas:SaveCompensationRecordResponse result = check pricefxClient->saveCompensationRecord(payload);
```

</div>
</details>

<details>
<summary>sendDocumentToSign</summary>

<div>

Send a Document to Sign

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Compensation whose data you want to send via the e-signature system |
| `payload` | <code>oas:CreateSignatureRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreateSignatureResponse|error`

**Sample code:**

```ballerina
oas:CreateSignatureResponse result = check pricefxClient->sendDocumentToSign(typedId, payload);
```

</div>
</details>

<details>
<summary>undoCompensationPlanRevocation</summary>

<div>

Undo Compensation Plan Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoCompensationPlanRevocation(typedId);
```

</div>
</details>

<details>
<summary>undoCompensationRecordRevocation</summary>

<div>

Undo Compensation Record Revocation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->undoCompensationRecordRevocation(typedId);
```

</div>
</details>

<details>
<summary>updateCompensationRecord</summary>

<div>

Update a Compensation Record

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCompensationRecordRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCompensationRecordResponse|error`

**Sample code:**

```ballerina
oas:UpdateCompensationRecordResponse result = check pricefxClient->updateCompensationRecord(payload);
```

</div>
</details>

<details>
<summary>updateCompensationType</summary>

<div>

Update a Compensation Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCompensationTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCompensationTypeEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateCompensationTypeEnvelope result = check pricefxClient->updateCompensationType(payload);
```

</div>
</details>

<details>
<summary>updateConditionType</summary>

<div>

Update a Condition Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateConditionTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateConditionTypeEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateConditionTypeEnvelope result = check pricefxClient->updateConditionType(payload);
```

</div>
</details>

<details>
<summary>updateQuoteContractRebateAgreement</summary>

<div>

Update a Quote/Contract/Rebate Agreement/Compensation Plan

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Compensation Plan you want to update |
| `payload` | <code>oas:ClicmanagerUpdatetypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateClicEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateClicEnvelope result = check pricefxClient->updateQuoteContractRebateAgreement(typedId, payload);
```

</div>
</details>

<details>
<summary>upsertCompensationPlan</summary>

<div>

Upsert a Compensation Plan

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpsertCompensationPlanRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpsertCompensationPlanResponse|error`

**Sample code:**

```ballerina
oas:UpsertCompensationPlanResponse result = check pricefxClient->upsertCompensationPlan(payload);
```

</div>
</details>

#### Claims

<details>
<summary>addClaim</summary>

<div>

Add a Claim

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddClaimRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddClaimResponse|error`

**Sample code:**

```ballerina
oas:AddClaimResponse result = check pricefxClient->addClaim(payload);
```

</div>
</details>

<details>
<summary>calculateClaim</summary>

<div>

Calculate a Claim

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the claim whose items you want to calculate |
| `payload` | <code>oas:CalculateClaimRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateClaimResponse|error`

**Sample code:**

```ballerina
oas:CalculateClaimResponse result = check pricefxClient->calculateClaim(typedId, payload);
```

</div>
</details>

<details>
<summary>cancelClaimCalculation</summary>

<div>

Cancel a Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the claim whose item calculation you want to cancel |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CancelClaimCalculationResponse|error`

**Sample code:**

```ballerina
oas:CancelClaimCalculationResponse result = check pricefxClient->cancelClaimCalculation(typedId, payload);
```

</div>
</details>

<details>
<summary>getSummary</summary>

<div>

Get a Summary

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetClaimItemsSummaryResponse|error`

**Sample code:**

```ballerina
oas:GetClaimItemsSummaryResponse result = check pricefxClient->getSummary(typedId, payload);
```

</div>
</details>

<details>
<summary>listClaims</summary>

<div>

List Claims + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListClaimsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListClaimsResponse|error`

**Sample code:**

```ballerina
oas:ListClaimsResponse result = check pricefxClient->listClaims(payload);
```

</div>
</details>

<details>
<summary>listItems</summary>

<div>

List Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListClaimItemsResponse|error`

**Sample code:**

```ballerina
oas:ListClaimItemsResponse result = check pricefxClient->listItems(typedId, payload);
```

</div>
</details>

<details>
<summary>rejectItems</summary>

<div>

Reject Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Claim whose items you want to reject |
| `payload` | <code>oas:RejectClaimItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RejectClaimItemsResponse|error`

**Sample code:**

```ballerina
oas:RejectClaimItemsResponse result = check pricefxClient->rejectItems(typedId, payload);
```

</div>
</details>

<details>
<summary>removeItems</summary>

<div>

Remove Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Claim whose items you want to remove |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RemoveClaimItemsResponse|error`

**Sample code:**

```ballerina
oas:RemoveClaimItemsResponse result = check pricefxClient->removeItems(typedId, payload);
```

</div>
</details>

<details>
<summary>submitClaim</summary>

<div>

Submit a Claim

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Claim you want to submit |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitClaimResponse|error`

**Sample code:**

```ballerina
oas:SubmitClaimResponse result = check pricefxClient->submitClaim(typedId, payload);
```

</div>
</details>

<details>
<summary>updateClaim</summary>

<div>

Update a Claim + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateClaimRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateClaimResponse|error`

**Sample code:**

```ballerina
oas:UpdateClaimResponse result = check pricefxClient->updateClaim(payload);
```

</div>
</details>

<details>
<summary>validateItems</summary>

<div>

Validate Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Claim whose items you want to validate |
| `payload` | <code>oas:ValidateClaimItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ValidateClaimItemsResponse|error`

**Sample code:**

```ballerina
oas:ValidateClaimItemsResponse result = check pricefxClient->validateItems(typedId, payload);
```

</div>
</details>

#### Claim Types

<details>
<summary>addClaimType</summary>

<div>

Add a Claim Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddClaimTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddClaimTypeResponse|error`

**Sample code:**

```ballerina
oas:AddClaimTypeResponse result = check pricefxClient->addClaimType(payload);
```

</div>
</details>

<details>
<summary>deleteClaimType</summary>

<div>

Delete a Claim Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteClaimTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteClaimTypeResponse|error`

**Sample code:**

```ballerina
oas:DeleteClaimTypeResponse result = check pricefxClient->deleteClaimType(payload);
```

</div>
</details>

<details>
<summary>listClaimTypes</summary>

<div>

List Claim Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListClaimTypesRequest</code> | Yes | The example of the request body contains the filter. The call returns Claim Types whose `name` equals to "claimType" |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListClaimTypesResponse|error`

**Sample code:**

```ballerina
oas:ListClaimTypesResponse result = check pricefxClient->listClaimTypes(payload);
```

</div>
</details>

<details>
<summary>updateClaimType</summary>

<div>

Update a Claim Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateClaimTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateClaimTypeResponse|error`

**Sample code:**

```ballerina
oas:UpdateClaimTypeResponse result = check pricefxClient->updateClaimType(payload);
```

</div>
</details>

#### Attachments

<details>
<summary>checkFileExists</summary>

<div>

Check a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `binaryDataId` | <code>string</code> | Yes | If the `typedId` is, for example, 1145.BD then the binaryDataId is **1145** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CheckFileExistsEnvelope|error`

**Sample code:**

```ballerina
oas:CheckFileExistsEnvelope result = check pricefxClient->checkFileExists(binaryDataId);
```

</div>
</details>

<details>
<summary>createUploadSlot</summary>

<div>

1. Create an Upload Slot

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:CreateUploadSlotQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:CreateUploadSlotEnvelope|error`

**Sample code:**

```ballerina
oas:CreateUploadSlotEnvelope result = check pricefxClient->createUploadSlot(queries);
```

</div>
</details>

<details>
<summary>deleteFile</summary>

<div>

Delete a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document whose attachment you want to delete |
| `binaryDataId` | <code>string</code> | Yes | If the `typedId` is, for example, 1145.BD then the binaryDataId is **1145** |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->deleteFile(typedId, binaryDataId, payload);
```

</div>
</details>

<details>
<summary>deleteUploadSlot</summary>

<div>

3. Delete an Upload Slot

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `slotId` | <code>string</code> | Yes | Enter the ID of the slot you want to delete |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UploadSlotOperationEnvelope|error`

**Sample code:**

```ballerina
oas:UploadSlotOperationEnvelope result = check pricefxClient->deleteUploadSlot(slotId);
```

</div>
</details>

<details>
<summary>downloadAttachmentData</summary>

<div>

Download an Attachment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `binaryDataId` | <code>string</code> | Yes | If the typedId is, for example, 1146.BD then the binaryDataId is **1146** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:DownloadAttachmentDataQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `byte[]|error`

**Sample code:**

```ballerina
byte[] result = check pricefxClient->downloadAttachmentData(binaryDataId, queries);
```

</div>
</details>

<details>
<summary>downloadFile</summary>

<div>

Download a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document you want to download the attachment from |
| `binaryDataId` | <code>string</code> | Yes | If the `typedId` is, for example, 1145.BD then the binaryDataId is **1145** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:DownloadFileQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:FileDownloadEnvelope|error`

**Sample code:**

```ballerina
oas:FileDownloadEnvelope result = check pricefxClient->downloadFile(typedId, binaryDataId, queries);
```

</div>
</details>

<details>
<summary>downloadFileViaPost</summary>

<div>

Download a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document you want to download the attachment from |
| `binaryDataId` | <code>string</code> | Yes | If the `typedId` is, for example, 1145.BD then the binaryDataId is **1145** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:DownloadFileViaPostQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->downloadFileViaPost(typedId, binaryDataId, queries);
```

</div>
</details>

<details>
<summary>editAttachment</summary>

<div>

2. Upload a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `ownerTypedId` | <code>string</code> | Yes | The `TypedId` of the document owning the attachment |
| `binaryDataId` | <code>string</code> | Yes | The `binaryDataId` of the attachment to replace |
| `slotId` | <code>string</code> | Yes | The upload `slot_id` containing the new file |
| `payload` | <code>oas:BinaryDataIdslotIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:FileDownloadEnvelope|error`

**Sample code:**

```ballerina
oas:FileDownloadEnvelope result = check pricefxClient->editAttachment(ownerTypedId, binaryDataId, slotId, payload);
```

</div>
</details>

<details>
<summary>getUploadProgress</summary>

<div>

Get Upload Progress

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uploadslot` | <code>string</code> | Yes | Upload Slot Id |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UploadSlotOperationEnvelope|error`

**Sample code:**

```ballerina
oas:UploadSlotOperationEnvelope result = check pricefxClient->getUploadProgress(uploadslot);
```

</div>
</details>

<details>
<summary>listFiles</summary>

<div>

List Files

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document you want to list attachments for |
| `payload` | <code>oas:BdmanagerListtypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListFilesEnvelope|error`

**Sample code:**

```ballerina
oas:ListFilesEnvelope result = check pricefxClient->listFiles(typedId, payload);
```

</div>
</details>

<details>
<summary>updateFile</summary>

<div>

Update a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document whose attachment's metadata you want to update |
| `payload` | <code>oas:BdmanagerUpdatetypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateFileEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateFileEnvelope result = check pricefxClient->updateFile(typedId, payload);
```

</div>
</details>

<details>
<summary>uploadFile</summary>

<div>

2. Upload a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the document you want to attach the file to |
| `slotId` | <code>string</code> | Yes | The ID of the slot you want to use for the upload. retrieve the slot ID using the `/uploadmanager.newuploadslot` (Create an Upload Slot) endpoint |
| `payload` | <code>oas:TypedIdslotIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:FileOperationEnvelope|error`

**Sample code:**

```ballerina
oas:FileOperationEnvelope result = check pricefxClient->uploadFile(typedId, slotId, payload);
```

</div>
</details>

#### Comments

<details>
<summary>addComment</summary>

<div>

Add a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CommentmanagerAddBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CommentOperationEnvelope|error`

**Sample code:**

```ballerina
oas:CommentOperationEnvelope result = check pricefxClient->addComment(payload);
```

</div>
</details>

<details>
<summary>deleteComment</summary>

<div>

Delete a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | Comment or CommentThread typedId |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCommentEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteCommentEnvelope result = check pricefxClient->deleteComment(typedId);
```

</div>
</details>

<details>
<summary>editComment</summary>

<div>

Edit a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the comment you want to edit |
| `payload` | <code>oas:CommentmanagerEdittypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CommentOperationEnvelope|error`

**Sample code:**

```ballerina
oas:CommentOperationEnvelope result = check pricefxClient->editComment(typedId, payload);
```

</div>
</details>

<details>
<summary>listCommentThreads</summary>

<div>

List Comment Threads

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the object you want to fetch comments for |
| `payload` | <code>oas:CommentmanagerFetchthreadstypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListCommentThreadsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ListCommentThreadsEnvelope|error`

**Sample code:**

```ballerina
oas:ListCommentThreadsEnvelope result = check pricefxClient->listCommentThreads(typedId, payload, queries);
```

</div>
</details>

<details>
<summary>replyToComment</summary>

<div>

Reply To a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CommentmanagerReplyBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CommentOperationEnvelope|error`

**Sample code:**

```ballerina
oas:CommentOperationEnvelope result = check pricefxClient->replyToComment(payload);
```

</div>
</details>

<details>
<summary>resolveComment</summary>

<div>

Resolve a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The typedId of the comment thread |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ResolveCommentEnvelope|error`

**Sample code:**

```ballerina
oas:ResolveCommentEnvelope result = check pricefxClient->resolveComment(typedId, payload);
```

</div>
</details>

<details>
<summary>unresolveComment</summary>

<div>

Unresolve a Comment

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The typedId of the comment thread |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ResolveCommentEnvelope|error`

**Sample code:**

```ballerina
oas:ResolveCommentEnvelope result = check pricefxClient->unresolveComment(typedId, payload);
```

</div>
</details>

#### Custom Forms

<details>
<summary>changeCustomFormStatus</summary>

<div>

Change a Custom Form Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Custom Form whose status you want to change |
| `payload` | <code>oas:ChangeCustomFormStatusRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ChangeCustomFormStatusResponse|error`

**Sample code:**

```ballerina
oas:ChangeCustomFormStatusResponse result = check pricefxClient->changeCustomFormStatus(typedId, payload);
```

</div>
</details>

<details>
<summary>createCustomForm</summary>

<div>

Create a Custom Form + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CreateCustomFormRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreateCustomFormEnvelope|error`

**Sample code:**

```ballerina
oas:CreateCustomFormEnvelope result = check pricefxClient->createCustomForm(payload);
```

</div>
</details>

<details>
<summary>createCustomFormRevision</summary>

<div>

Create a Custom Form Revision

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Custom Form you want to create a revision from |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CustomFormRevisionEnvelope|error`

**Sample code:**

```ballerina
oas:CustomFormRevisionEnvelope result = check pricefxClient->createCustomFormRevision(typedId, payload);
```

</div>
</details>

<details>
<summary>createCustomFormType</summary>

<div>

Create a Custom Form Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CreateCustomFormTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreateCustomFormTypeResponse|error`

**Sample code:**

```ballerina
oas:CreateCustomFormTypeResponse result = check pricefxClient->createCustomFormType(payload);
```

</div>
</details>

<details>
<summary>deleteCustomForm</summary>

<div>

Delete a Custom Form

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCustomFormRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->deleteCustomForm(payload);
```

</div>
</details>

<details>
<summary>deleteCustomFormType</summary>

<div>

Delete a Custom Form Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCFOTBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCustomFormTypeEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteCustomFormTypeEnvelope result = check pricefxClient->deleteCustomFormType(payload);
```

</div>
</details>

<details>
<summary>duplicateCustomForm</summary>

<div>

Duplicate a Custom Form

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Custom Form you want to duplicate |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CustomFormRevisionEnvelope|error`

**Sample code:**

```ballerina
oas:CustomFormRevisionEnvelope result = check pricefxClient->duplicateCustomForm(typedId, payload);
```

</div>
</details>

<details>
<summary>getCustomForm</summary>

<div>

Get a Custom Form

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Custom Form you want to retrieve details for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCustomFormResponse|error`

**Sample code:**

```ballerina
oas:GetCustomFormResponse result = check pricefxClient->getCustomForm(typedId);
```

</div>
</details>

<details>
<summary>listCustomFormTypes</summary>

<div>

List Custom Form Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCustomFormTypesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCustomFormTypesResponse|error`

**Sample code:**

```ballerina
oas:ListCustomFormTypesResponse result = check pricefxClient->listCustomFormTypes(payload);
```

</div>
</details>

<details>
<summary>listCustomForms</summary>

<div>

List Custom Forms

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListCustomFormsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCustomFormsEnvelope|error`

**Sample code:**

```ballerina
oas:ListCustomFormsEnvelope result = check pricefxClient->listCustomForms(payload);
```

</div>
</details>

<details>
<summary>previewCustomFormWorkflow</summary>

<div>

Preview a Custom Form Workflow

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:PreviewCustomFormWorkflowResponse|error`

**Sample code:**

```ballerina
oas:PreviewCustomFormWorkflowResponse result = check pricefxClient->previewCustomFormWorkflow(payload);
```

</div>
</details>

<details>
<summary>updateCustomForm</summary>

<div>

Update a Custom Form

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCustomFormRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCustomFormEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateCustomFormEnvelope result = check pricefxClient->updateCustomForm(payload);
```

</div>
</details>

<details>
<summary>updateCustomFormType</summary>

<div>

Update a Custom Form Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCustomFormTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCustomFormTypeResponse|error`

**Sample code:**

```ballerina
oas:UpdateCustomFormTypeResponse result = check pricefxClient->updateCustomFormType(payload);
```

</div>
</details>

#### Data Change Requests

<details>
<summary>addDataChangeRequest</summary>

<div>

Add a Data Change Request

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddDCRRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddDCRResponse|error`

**Sample code:**

```ballerina
oas:AddDCRResponse result = check pricefxClient->addDataChangeRequest(payload);
```

</div>
</details>

<details>
<summary>addDataChangeRequestItem</summary>

<div>

Add a Data Change Request Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request you want to add the Data Change Request Item to |
| `payload` | <code>oas:AddDCRIRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddDCRIResponse|error`

**Sample code:**

```ballerina
oas:AddDCRIResponse result = check pricefxClient->addDataChangeRequestItem(id, payload);
```

</div>
</details>

<details>
<summary>deleteDataChangeRequestItem</summary>

<div>

Delete a Data Change Request Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request whose item you want to delete |
| `payload` | <code>oas:DeleteDCRIRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteDCRIResponse|error`

**Sample code:**

```ballerina
oas:DeleteDCRIResponse result = check pricefxClient->deleteDataChangeRequestItem(id, payload);
```

</div>
</details>

<details>
<summary>deleteDataChangeRequestMassChange</summary>

<div>

Delete a Data Change Request Mass Change

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request |
| `payload` | <code>oas:DcrmanagerDeletemassopidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DataChangeRequestMassChangeEnvelope|error`

**Sample code:**

```ballerina
oas:DataChangeRequestMassChangeEnvelope result = check pricefxClient->deleteDataChangeRequestMassChange(id, payload);
```

</div>
</details>

<details>
<summary>getDataChangeRequest</summary>

<div>

Get a Data Change Request

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request you want to retrieve |
| `payload` | <code>oas:GetDCRRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetDCRResponse|error`

**Sample code:**

```ballerina
oas:GetDCRResponse result = check pricefxClient->getDataChangeRequest(id, payload);
```

</div>
</details>

<details>
<summary>getDataChangeRequestChanges</summary>

<div>

Get a Data Change Request (changes only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request you want to retrieve changed items for |
| `payload` | <code>oas:GetDCRRequestChangeOnly</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetDCRResponseChangeOnly|error`

**Sample code:**

```ballerina
oas:GetDCRResponseChangeOnly result = check pricefxClient->getDataChangeRequestChanges(id, payload);
```

</div>
</details>

<details>
<summary>getDataChangeRequestMassChanges</summary>

<div>

Get Data Change Request Mass Changes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request |
| `payload` | <code>oas:DcrmanagerFetchmassopidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DataChangeRequestMassChangeEnvelope|error`

**Sample code:**

```ballerina
oas:DataChangeRequestMassChangeEnvelope result = check pricefxClient->getDataChangeRequestMassChanges(id, payload);
```

</div>
</details>

<details>
<summary>massEditDataChangeRequestItems</summary>

<div>

Mass Edit Data Change Request Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request |
| `payload` | <code>oas:DcrmanagerAddmassopidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DataChangeRequestMassChangeEnvelope|error`

**Sample code:**

```ballerina
oas:DataChangeRequestMassChangeEnvelope result = check pricefxClient->massEditDataChangeRequestItems(id, payload);
```

</div>
</details>

<details>
<summary>submitDataChangeRequest</summary>

<div>

Submit a Data Change Request

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the DCR to be submitted |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitDCRResponse|error`

**Sample code:**

```ballerina
oas:SubmitDCRResponse result = check pricefxClient->submitDataChangeRequest(id, payload);
```

</div>
</details>

<details>
<summary>submitDataChangeRequestAsync</summary>

<div>

Submit a Data Change Request (async)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the DCR to be submitted |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitDCRAsyncResponse|error`

**Sample code:**

```ballerina
oas:SubmitDCRAsyncResponse result = check pricefxClient->submitDataChangeRequestAsync(id, payload);
```

</div>
</details>

<details>
<summary>updateDataChangeRequestItem</summary>

<div>

Update a Data Change Request Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request whose item you want to update |
| `payload` | <code>oas:UpdateDCRIRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateDCRIResponse|error`

**Sample code:**

```ballerina
oas:UpdateDCRIResponse result = check pricefxClient->updateDataChangeRequestItem(id, payload);
```

</div>
</details>

<details>
<summary>updateDataChangeRequestMassChanges</summary>

<div>

Update Data Change Request Mass Changes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Data Change Request |
| `payload` | <code>oas:DcrmanagerUpdatemassopidBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DataChangeRequestMassChangeEnvelope|error`

**Sample code:**

```ballerina
oas:DataChangeRequestMassChangeEnvelope result = check pricefxClient->updateDataChangeRequestMassChanges(id, payload);
```

</div>
</details>

#### Data Manager

<details>
<summary>createDMFieldCollection</summary>

<div>

Create a DMFieldCollection

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `fcType` | <code>"DMDS"&#124;"DMT"</code> | Yes | The type of FC (FieldCollection) you want to create |
| `payload` | <code>oas:DatamartCreatefcfcTypeBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->createDMFieldCollection(fcType, payload);
```

</div>
</details>

<details>
<summary>createDataManagerEntity</summary>

<div>

Create a Data Manager Entity

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"DMF"&#124;"DM"&#124;"DMDS"</code> | Yes | The type code of the **Field Collection** you want to update |
| `payload` | <code>oas:CreateDataManagerEntityRequest</code> | Yes | Either `uniqueName` or `typedId` must be provided in the request |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:dmobjectResponse|error`

**Sample code:**

```ballerina
oas:dmobjectResponse result = check pricefxClient->createDataManagerEntity(typeCode, payload);
```

</div>
</details>

<details>
<summary>deleteDataManagerEntity</summary>

<div>

Delete a Data Manager Entity

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"DM"&#124;"DMF"&#124;"DMDS"</code> | Yes | The type code of the **Field Collection** you want to delete |
| `payload` | <code>oas:DeleteDataManagerEntityRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteDataManagerEntityResponse|error`

**Sample code:**

```ballerina
oas:DeleteDataManagerEntityResponse result = check pricefxClient->deleteDataManagerEntity(typeCode, payload);
```

</div>
</details>

<details>
<summary>deleteDatamartOrphanObjects</summary>

<div>

Delete Datamart Orphan Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DatamartOrphanObjectsEnvelope|error`

**Sample code:**

```ballerina
oas:DatamartOrphanObjectsEnvelope result = check pricefxClient->deleteDatamartOrphanObjects();
```

</div>
</details>

<details>
<summary>executeDataLoadLogic</summary>

<div>

Execute a Data Load Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Data Load you want to evaluate |
| `logicName` | <code>string</code> | Yes | The name of the logic you want to execute |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteDataLoadLogicResponse|error`

**Sample code:**

```ballerina
oas:ExecuteDataLoadLogicResponse result = check pricefxClient->executeDataLoadLogic(typedId, logicName);
```

</div>
</details>

<details>
<summary>exportCsvFile</summary>

<div>

Export a CSV File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ExportCSVFileRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportCsvFileQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->exportCsvFile(payload, queries);
```

</div>
</details>

<details>
<summary>exportDatamart</summary>

<div>

Export Datamart

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `fcTypedIdOrSourceName` | <code>string</code> | Yes | Restricts the export to a specific source, identified by either the 'typedId' or 'sourceName'. |
| `payload` | <code>oas:ExportDatamartRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportDatamartQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ExportDatamartResponse|error`

**Sample code:**

```ballerina
oas:ExportDatamartResponse result = check pricefxClient->exportDatamart(fcTypedIdOrSourceName, payload, queries);
```

</div>
</details>

<details>
<summary>exportExcelFileXlsx</summary>

<div>

Export an Excel File (XLSX)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ExportExcelFileRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExportExcelFileXlsxQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->exportExcelFileXlsx(payload, queries);
```

</div>
</details>

<details>
<summary>fetchDataMartObject</summary>

<div>

Get a DM Object - **typedUniquename** – Format: "*&lt;typeCode&gt;.&lt;uniqueName&gt;*" (e.g., DMDS.SalesTransactions) - **typedId** – Format: "*&lt;dbId&gt;.&lt;typeCode&gt;*" (e.g., 123456.DMDS)' - **"*"** (asterisk) – Asterisk can be used when you are providing a **source$query** in `data` within the request body

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `objectId` | <code>string</code> | Yes | Use one of the following object identifiers: |
| `payload` | <code>oas:GetDMObjectRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:FetchDataMartObjectQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:GetDMObjectResponse|error`

**Sample code:**

```ballerina
oas:GetDMObjectResponse result = check pricefxClient->fetchDataMartObject(objectId, payload, queries);
```

</div>
</details>

<details>
<summary>getActionStatus</summary>

<div>

Get Action Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `actionUUID` | <code>string</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetActionStatusResponse|error`

**Sample code:**

```ballerina
oas:GetActionStatusResponse result = check pricefxClient->getActionStatus(actionUUID);
```

</div>
</details>

<details>
<summary>getDataMartObject</summary>

<div>

Get a DM Object - **typedUniquename** – Format: "*&lt;typeCode&gt;.&lt;uniqueName&gt;*" (e.g., DMDS.SalesTransactions) - **typedId** – Format: "*&lt;dbId&gt;.&lt;typeCode&gt;*" (e.g., 123456.DMDS)' - **"*"** (asterisk) – Asterisk can be used when you are providing a **source$query** in `data` within the request body

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `objectId` | <code>string</code> | Yes | Use one of the following object identifiers: |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:GetDataMartObjectQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:DataMartObjectEnvelope|error`

**Sample code:**

```ballerina
oas:DataMartObjectEnvelope result = check pricefxClient->getDataMartObject(objectId, queries);
```

</div>
</details>

<details>
<summary>getDmExportFile</summary>

<div>

Get a DM Export File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `fileName` | <code>string</code> | Yes | The name of the file previously created by a `datamart.export` request. The filename needs to be an exact match - no wildcards allowed, hence only one file at the time can be fetched |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->getDmExportFile(fileName);
```

</div>
</details>

<details>
<summary>getDmObjectNo</summary>

<div>

Get a DM Object (no count) - **typedUniquename** – Format: "*&lt;typeCode&gt;.&lt;uniqueName&gt;*" (e.g., DMDS.SalesTransactions) - **typedId** – Format: "*&lt;dbId&gt;.&lt;typeCode&gt;*" (e.g., 123456.DMDS) - **"*"** (asterisk) – Asterisk can be used when you are providing a **source$query** in `data` within the request body

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `objectId` | <code>string</code> | Yes | Use one of the following object identifiers: |
| `payload` | <code>oas:GetDMObjectNoCountRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetDMObjectNoCountResponse|error`

**Sample code:**

```ballerina
oas:GetDMObjectNoCountResponse result = check pricefxClient->getDmObjectNo(objectId, payload);
```

</div>
</details>

<details>
<summary>importDataLoad</summary>

<div>

Import a Data Load

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ImportDataLoadRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->importDataLoad(payload);
```

</div>
</details>

<details>
<summary>importDataMartFile</summary>

<div>

Import a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `slotId` | <code>string</code> | Yes | The `id` of the slot. Create the slot and retrieve the `id` using the **/uploadmanager.newuploadslot** endpoint |
| `typedId` | <code>string</code> | Yes | The `typedId` of the Data Manager entity |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->importDataMartFile(slotId, typedId);
```

</div>
</details>

<details>
<summary>listCharts</summary>

<div>

List Charts

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListChartsResponse|error`

**Sample code:**

```ballerina
oas:ListChartsResponse result = check pricefxClient->listCharts();
```

</div>
</details>

<details>
<summary>listDataLoads</summary>

<div>

List Data Loads

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListDataLoadsResponse|error`

**Sample code:**

```ballerina
oas:ListDataLoadsResponse result = check pricefxClient->listDataLoads();
```

</div>
</details>

<details>
<summary>listDataLoadsWith</summary>

<div>

List Data Loads (with validation and schedules)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListDataLoadsWithValidationResponse|error`

**Sample code:**

```ballerina
oas:ListDataLoadsWithValidationResponse result = check pricefxClient->listDataLoadsWith();
```

</div>
</details>

<details>
<summary>listDataManagerEntities</summary>

<div>

List Data Manager Entities

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"DM"&#124;"DMDS"&#124;"DMF"&#124;"DMT"</code> | Yes | The type code of the **Field Collection** |
| `payload` | <code>oas:ListDataManagerEntitiesRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:dmobjectResponse|error`

**Sample code:**

```ballerina
oas:dmobjectResponse result = check pricefxClient->listDataManagerEntities(typeCode, payload);
```

</div>
</details>

<details>
<summary>listDatamartOrphanObjects</summary>

<div>

List Datamart Orphan Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DatamartOrphanObjectsEnvelope|error`

**Sample code:**

```ballerina
oas:DatamartOrphanObjectsEnvelope result = check pricefxClient->listDatamartOrphanObjects();
```

</div>
</details>

<details>
<summary>listRollups</summary>

<div>

List Rollups

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListRollupsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListRollupsResponse|error`

**Sample code:**

```ballerina
oas:ListRollupsResponse result = check pricefxClient->listRollups(payload);
```

</div>
</details>

<details>
<summary>massEditDataMartObject</summary>

<div>

Mass Edit

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the object you want to perform the mass edit action for |
| `payload` | <code>oas:MassEditRequest1</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassEditDatamartResponse|error`

**Sample code:**

```ballerina
oas:MassEditDatamartResponse result = check pricefxClient->massEditDataMartObject(typedId, payload);
```

</div>
</details>

<details>
<summary>queryDataManagerObject</summary>

<div>

Query a Data Manager Object

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:QueryDataManagerObjectRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:QueryDataManagerObjectQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:QueryDataManagerObjectResponse|error`

**Sample code:**

```ballerina
oas:QueryDataManagerObjectResponse result = check pricefxClient->queryDataManagerObject(payload, queries);
```

</div>
</details>

<details>
<summary>restoreDefaultDataSources</summary>

<div>

Restore Default Data Sources

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `dataSourceName` | <code>"Product"&#124;"Customer"&#124;"uom"&#124;"ccy"&#124;"cal"</code> | Yes | The name of the Data Source you want to create. |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RestoreDefaultDataSourcesResponse|error`

**Sample code:**

```ballerina
oas:RestoreDefaultDataSourcesResponse result = check pricefxClient->restoreDefaultDataSources(dataSourceName);
```

</div>
</details>

<details>
<summary>runDataLoad</summary>

<div>

Run a Data Load

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:RunDataLoadRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RunDataLoadResponse|error`

**Sample code:**

```ballerina
oas:RunDataLoadResponse result = check pricefxClient->runDataLoad(payload);
```

</div>
</details>

<details>
<summary>saveDataLoad</summary>

<div>

Save a Data Load

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DatamartUpdatedataloadBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DataLoadEnvelope|error`

**Sample code:**

```ballerina
oas:DataLoadEnvelope result = check pricefxClient->saveDataLoad(payload);
```

</div>
</details>

<details>
<summary>sqlQueryDataManagerObject</summary>

<div>

SQL Query a Data Manager Object

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DatamartSqlqueryBody</code> | Yes | `sources` that SQL can use are query definitions. The sources become CTEs (Common Table Expression) in the final SQL. These are then used as a reference in the main query instead of referring to the actual tables directly. The request example compares the volume by month 2019 to 2020 |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:SqlQueryDataManagerObjectQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:QueryDataManagerObjectResponse|error`

**Sample code:**

```ballerina
oas:QueryDataManagerObjectResponse result = check pricefxClient->sqlQueryDataManagerObject(payload, queries);
```

</div>
</details>

<details>
<summary>updateDataManagerEntity</summary>

<div>

Update a Data Manager Entity

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"DMF"&#124;"DM"&#124;"DMDS"</code> | Yes | The type code of the **Field Collection** you want to update |
| `payload` | <code>oas:UpdateDataManagerEntityRequest</code> | Yes | Either `uniqueName` or `typedId` must be provided in the request |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:dmobjectResponse|error`

**Sample code:**

```ballerina
oas:dmobjectResponse result = check pricefxClient->updateDataManagerEntity(typeCode, payload);
```

</div>
</details>

<details>
<summary>uploadBulkDataToDataSource</summary>

<div>

Upload a Bulk Data to Data Source

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `datasourceUniqueName` | <code>string</code> | Yes | The unique name of the Data Source where you want to upload the data to. You can also use `typedId` or the source name |
| `payload` | <code>oas:UploadBulkDataToDataSourceRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:BulkDataUploadEnvelope|error`

**Sample code:**

```ballerina
oas:BulkDataUploadEnvelope result = check pricefxClient->uploadBulkDataToDataSource(datasourceUniqueName, payload);
```

</div>
</details>

#### Imports

<details>
<summary>deleteImportChanges</summary>

<div>

Delete Import Changes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ImportmanagerDeletechangesBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->deleteImportChanges(payload);
```

</div>
</details>

<details>
<summary>listImportManagerChanges</summary>

<div>

List ImportManager Changes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes |  |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListImportManagerChangesEnvelope|error`

**Sample code:**

```ballerina
oas:ListImportManagerChangesEnvelope result = check pricefxClient->listImportManagerChanges(uniqueName, payload);
```

</div>
</details>

<details>
<summary>massDeleteImports</summary>

<div>

Mass Delete Imports

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:ImportmanagerMassdeletetypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassDeleteImportsEnvelope|error`

**Sample code:**

```ballerina
oas:MassDeleteImportsEnvelope result = check pricefxClient->massDeleteImports(typedId, payload);
```

</div>
</details>

<details>
<summary>massEditImports</summary>

<div>

Mass Edit Imports

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:ImportmanagerMassedittypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassEditImportsEnvelope|error`

**Sample code:**

```ballerina
oas:MassEditImportsEnvelope result = check pricefxClient->massEditImports(typedId, payload);
```

</div>
</details>

<details>
<summary>saveImportChange</summary>

<div>

Save Import Change

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveImportChangeEnvelope|error`

**Sample code:**

```ballerina
oas:SaveImportChangeEnvelope result = check pricefxClient->saveImportChange(payload);
```

</div>
</details>

<details>
<summary>submitChanges</summary>

<div>

Submit Changes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the import |
| `payload` | <code>oas:ImportmanagerSubmittypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ImportManagerUploadEnvelope|error`

**Sample code:**

```ballerina
oas:ImportManagerUploadEnvelope result = check pricefxClient->submitChanges(typedId, payload);
```

</div>
</details>

<details>
<summary>uploadExcelToImportManager</summary>

<div>

Upload Excel to Import Manager

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"P"&#124;"PX"</code> | Yes | Target object type code |
| `target` | <code>string</code> | Yes | Provides additional details about the target object, such as specifying a PX name if required |
| `slotId` | <code>string</code> | Yes | ID of the Upload Slot |
| `payload` | <code>oas:TypeCodetargetBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:UploadExcelToImportManagerQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ImportManagerUploadEnvelope|error`

**Sample code:**

```ballerina
oas:ImportManagerUploadEnvelope result = check pricefxClient->uploadExcelToImportManager(typeCode, target, slotId, payload, queries);
```

</div>
</details>

#### Lookup Tables / Company Parameters

<details>
<summary>addLookupTable</summary>

<div>

Add a Lookup Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddLookupTableRequest</code> | Yes | The request must contain all fields that are part of the business key for that object and all non-nullable fields |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddLookupTableResponse|error`

**Sample code:**

```ballerina
oas:AddLookupTableResponse result = check pricefxClient->addLookupTable(payload);
```

</div>
</details>

<details>
<summary>addLookupTableValue</summary>

<div>

Add a Lookup Table Value

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:AddLookupTableValueRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddLookupTableValueResponse|error`

**Sample code:**

```ballerina
oas:AddLookupTableValueResponse result = check pricefxClient->addLookupTableValue(tableId, payload);
```

</div>
</details>

<details>
<summary>copyLookupTable</summary>

<div>

Copy a Lookup Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table you want to copy |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyLookupTableResponse|error`

**Sample code:**

```ballerina
oas:CopyLookupTableResponse result = check pricefxClient->copyLookupTable(tableId);
```

</div>
</details>

<details>
<summary>deleteColumnValuesMatrix</summary>

<div>

Delete Column Values (Matrix only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `columnName` | <code>string</code> | Yes | Enter the name of the column you want to delete values from |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->deleteColumnValuesMatrix(tableId, columnName);
```

</div>
</details>

<details>
<summary>deleteLookupTable</summary>

<div>

Delete a Lookup Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteLookupTableRequest</code> | Yes | Specify the `typedId` of the Lookup Table (Company Parameters) you want to delete |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteLookupTableResponse|error`

**Sample code:**

```ballerina
oas:DeleteLookupTableResponse result = check pricefxClient->deleteLookupTable(payload);
```

</div>
</details>

<details>
<summary>deleteLookupTableValue</summary>

<div>

Delete a Lookup Table Value + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:DeleteLookupTableValueRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteLookupTableValueResponse|error`

**Sample code:**

```ballerina
oas:DeleteLookupTableValueResponse result = check pricefxClient->deleteLookupTableValue(tableId, payload);
```

</div>
</details>

<details>
<summary>getLogicReferences</summary>

<div>

Get Logic References

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table you want to retrieve logic references for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetLogicReferencesResponse|error`

**Sample code:**

```ballerina
oas:GetLogicReferencesResponse result = check pricefxClient->getLogicReferences(tableId);
```

</div>
</details>

<details>
<summary>insertBulkDataToLookupTable</summary>

<div>

Insert Bulk Data to Lookup Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"JLTV"&#124;"JLTVM"&#124;"LT"&#124;"LTT"&#124;"LTV"&#124;"MLTV"&#124;"MLTV2"&#124;"MLTV3"&#124;"MLTV4"&#124;"MLTV5"&#124;"MLTV6"&#124;"MLTVM"</code> | Yes | Enter the type code of the Lookup Table entity you want to insert a data to |
| `payload` | <code>oas:InsertBulkDataToLookupTableRequest</code> | Yes | We used `/lookuptablemanager.loaddata/MLTV` in the request example to insert bulk data to Matrix Lookup Table. Notice that the `lookupTable` is used in the `header` section and then ID of the Lookup Table in the `data` section |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:InsertBulkDataLookupTableResponse|error`

**Sample code:**

```ballerina
oas:InsertBulkDataLookupTableResponse result = check pricefxClient->insertBulkDataToLookupTable(typeCode, payload);
```

</div>
</details>

<details>
<summary>listAllLookupTableValues</summary>

<div>

List All Lookup Table Values

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:ListAllLookupTableValuesRequest</code> | Yes | You can specify the start and end row to limit the number of retrieved records |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListAllLookupTableValuesQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ListAllLookupTableValuesResponse|error`

**Sample code:**

```ballerina
oas:ListAllLookupTableValuesResponse result = check pricefxClient->listAllLookupTableValues(tableId, payload, queries);
```

</div>
</details>

<details>
<summary>listAllLookupTables</summary>

<div>

List All Lookup Tables

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListAllLookupTablesRequest</code> | Yes | You can specify the start and end row to limit the number of retrieved Lookup Tables / Company Parameters |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListAllLookupTablesResponse|error`

**Sample code:**

```ballerina
oas:ListAllLookupTablesResponse result = check pricefxClient->listAllLookupTables(payload);
```

</div>
</details>

<details>
<summary>massDeleteLookupTableValues</summary>

<div>

Mass Delete Lookup Table Values + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:TableIdBatchBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:MassDeleteLookupTableValuesQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:DeleteLookupTableValueResponse1|error`

**Sample code:**

```ballerina
oas:DeleteLookupTableValueResponse1 result = check pricefxClient->massDeleteLookupTableValues(tableId, payload, queries);
```

</div>
</details>

<details>
<summary>massEditLookupTable</summary>

<div>

Mass Edit

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | The ID of the Lookup Table whose values you want to update |
| `payload` | <code>oas:MassEditRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassEditResponse|error`

**Sample code:**

```ballerina
oas:MassEditResponse result = check pricefxClient->massEditLookupTable(tableId, payload);
```

</div>
</details>

<details>
<summary>updateLookupTable</summary>

<div>

Update a Lookup Table + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateLookupTableRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateLookupTableResponse|error`

**Sample code:**

```ballerina
oas:UpdateLookupTableResponse result = check pricefxClient->updateLookupTable(payload);
```

</div>
</details>

<details>
<summary>updateLookupTableValue</summary>

<div>

Update a Lookup Table Value

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:UpdateLookupTableValueRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateLookupTableValueResponse|error`

**Sample code:**

```ballerina
oas:UpdateLookupTableValueResponse result = check pricefxClient->updateLookupTableValue(tableId, payload);
```

</div>
</details>

<details>
<summary>upsertLookupTableValue</summary>

<div>

Upsert a Lookup Table Value

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableId` | <code>string</code> | Yes | Enter the ID of the table. The ID can be retrieved using the `/lookuptablemanager.fetch` method |
| `payload` | <code>oas:UpsertLookupTableValueRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpsertLookupTableValueResponse|error`

**Sample code:**

```ballerina
oas:UpsertLookupTableValueResponse result = check pricefxClient->upsertLookupTableValue(tableId, payload);
```

</div>
</details>

#### Key-Value Store

<details>
<summary>countKeys</summary>

<div>

Count Keys

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | The table to count keys from |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->countKeys(tableName);
```

</div>
</details>

<details>
<summary>createKvTable</summary>

<div>

Create a KV Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want create. Only lower case letters, numbers and underscores are allowed. Do not use special characters |
| `payload` | <code>oas:CreateKVTableRequest</code> | Yes | The sample request creates a table with four columns: sku, customer, record and payload (TEXT).&lt;br&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->createKvTable(tableName, payload);
```

</div>
</details>

<details>
<summary>deleteKey</summary>

<div>

Delete a Key

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes |  |
| `payload` | <code>oas:DeleteKVKeyRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->deleteKey(tableName, payload);
```

</div>
</details>

<details>
<summary>dropKvTable</summary>

<div>

Drop a KV Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want drop. Only lower case letters, numbers and underscores are allowed. Do not use special characters |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `record`

**Sample code:**

```ballerina
record result = check pricefxClient->dropKvTable(tableName, payload);
```

</div>
</details>

<details>
<summary>getKey</summary>

<div>

Get a Key

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want to retrieve the "payload" from |
| `payload` | <code>oas:GetKVKeyRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->getKey(tableName, payload);
```

</div>
</details>

<details>
<summary>getTableInfo</summary>

<div>

Get a Table Info

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want to retrieve information about |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetKVTableInfoResponse|error`

**Sample code:**

```ballerina
oas:GetKVTableInfoResponse result = check pricefxClient->getTableInfo(tableName);
```

</div>
</details>

<details>
<summary>insertBulkKvData</summary>

<div>

Insert Bulk KV Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want upload data to |
| `payload` | <code>oas:InsertBulkKVDataRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->insertBulkKvData(tableName, payload);
```

</div>
</details>

<details>
<summary>listKvTables</summary>

<div>

List KV Tables

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListKVTablesResponse|error`

**Sample code:**

```ballerina
oas:ListKVTablesResponse result = check pricefxClient->listKvTables();
```

</div>
</details>

<details>
<summary>searchKvTable</summary>

<div>

Search a KV Table + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want to search the pattern for |
| `payload` | <code>oas:SearchKVTableRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SearchKvTableEnvelope[]|error`

**Sample code:**

```ballerina
oas:SearchKvTableEnvelope[] result = check pricefxClient->searchKvTable(tableName, payload);
```

</div>
</details>

<details>
<summary>truncateTable</summary>

<div>

Truncate a Table

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | The table you want to remove the keys from |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:TruncateKVTableResponse|error`

**Sample code:**

```ballerina
oas:TruncateKVTableResponse result = check pricefxClient->truncateTable(tableName);
```

</div>
</details>

<details>
<summary>upsertKey</summary>

<div>

Upsert a Key + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `tableName` | <code>string</code> | Yes | A name of the table you want to upsert the key into |
| `payload` | <code>oas:UpsertKVKeyRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpsertKVKeyResponse|error`

**Sample code:**

```ballerina
oas:UpsertKVKeyResponse result = check pricefxClient->upsertKey(tableName, payload);
```

</div>
</details>

#### Logics

<details>
<summary>copyLogic</summary>

<div>

Copy a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic. you want to copy. The `id` is the `typedId` without the **F** suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.F**  is **2147484837** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CopyLogicResponse|error`

**Sample code:**

```ballerina
oas:CopyLogicResponse result = check pricefxClient->copyLogic(id);
```

</div>
</details>

<details>
<summary>deleteLogic</summary>

<div>

Delete a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic you want to delete. `id`  is the `typedId` without **F** suffix. For example, the `id` attribute of the item with `typedId` = **2147484835.F** is **2147484835** |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteLogicResponse|error`

**Sample code:**

```ballerina
oas:DeleteLogicResponse result = check pricefxClient->deleteLogic(id);
```

</div>
</details>

<details>
<summary>executeLibraryFunction</summary>

<div>

Execute Library Function

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `formulaName` | <code>string</code> | Yes | Name of the formula library containing the function |
| `elementName` | <code>string</code> | Yes | Name of the library element containing the function |
| `functionName` | <code>string</code> | Yes | Name of the function to execute |
| `payload` | <code>oas:ElementNamefunctionNameBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->executeLibraryFunction(formulaName, elementName, functionName, payload);
```

</div>
</details>

<details>
<summary>executeLogicInService</summary>

<div>

Execute a Logic Without a Context in a Service + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to execute |
| `payload` | <code>record &#123;record &#123;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:logicResponse|error`

**Sample code:**

```ballerina
oas:logicResponse result = check pricefxClient->executeLogicInService(uniqueName, payload);
```

</div>
</details>

<details>
<summary>executeLogicInServiceReadOnly</summary>

<div>

Execute a Logic Without a Context in a Service (Read-Only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to execute |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteLogicReadOnlyResponse|error`

**Sample code:**

```ballerina
oas:ExecuteLogicReadOnlyResponse result = check pricefxClient->executeLogicInServiceReadOnly(uniqueName);
```

</div>
</details>

<details>
<summary>executeLogicRead</summary>

<div>

Execute a Logic (Read-Only)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to execute |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteLogicReadOnlyResponse|error`

**Sample code:**

```ballerina
oas:ExecuteLogicReadOnlyResponse result = check pricefxClient->executeLogicRead(uniqueName);
```

</div>
</details>

<details>
<summary>executeLogicWithout</summary>

<div>

Execute a Logic (Without a Context) + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to execute |
| `payload` | <code>record &#123;record &#123;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ExecuteLogicWithoutQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ExecuteLogicWithoutProductContextResponse|error`

**Sample code:**

```ballerina
oas:ExecuteLogicWithoutProductContextResponse result = check pricefxClient->executeLogicWithout(uniqueName, payload, queries);
```

</div>
</details>

<details>
<summary>executeNamedProductLogic</summary>

<div>

Execute a Logic + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sku` | <code>string</code> | Yes | The `sku` or `typedId` of the product you want to execute the assigned logic for |
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to execute |
| `payload` | <code>record &#123;record &#123;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteLogicResponse|error`

**Sample code:**

```ballerina
oas:ExecuteLogicResponse result = check pricefxClient->executeNamedProductLogic(sku, uniqueName, payload);
```

</div>
</details>

<details>
<summary>executeProductLogic</summary>

<div>

Execute an Assigned Logic + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `sku` | <code>string</code> | Yes | The `sku` or `typedId` of the product you want to execute the logic for |
| `payload` | <code>record &#123;record &#123;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteAssignedLogicResponse|error`

**Sample code:**

```ballerina
oas:ExecuteAssignedLogicResponse result = check pricefxClient->executeProductLogic(sku, payload);
```

</div>
</details>

<details>
<summary>generateParameters</summary>

<div>

Generate Parameters

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:GenerateParametersRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GenerateParametersResponse|error`

**Sample code:**

```ballerina
oas:GenerateParametersResponse result = check pricefxClient->generateParameters(payload);
```

</div>
</details>

<details>
<summary>getDefaultPricingLogicName</summary>

<div>

Get a Default Pricing Logic Name

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetDefaultPricingLogicNameResponse|error`

**Sample code:**

```ballerina
oas:GetDefaultPricingLogicNameResponse result = check pricefxClient->getDefaultPricingLogicName();
```

</div>
</details>

<details>
<summary>getLogic</summary>

<div>

Get a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic you want to retrieve details for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetLogicResponse|error`

**Sample code:**

```ballerina
oas:GetLogicResponse result = check pricefxClient->getLogic(id);
```

</div>
</details>

<details>
<summary>listElements</summary>

<div>

List Elements

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to list elements for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListElementsResponse|error`

**Sample code:**

```ballerina
oas:ListElementsResponse result = check pricefxClient->listElements(uniqueName);
```

</div>
</details>

<details>
<summary>listFunctions</summary>

<div>

List Functions

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListFunctionsResponse|error`

**Sample code:**

```ballerina
oas:ListFunctionsResponse result = check pricefxClient->listFunctions();
```

</div>
</details>

<details>
<summary>listLibraries</summary>

<div>

List Libraries

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLibrariesResponse|error`

**Sample code:**

```ballerina
oas:ListLibrariesResponse result = check pricefxClient->listLibraries();
```

</div>
</details>

<details>
<summary>listLogicParametersInput</summary>

<div>

List Logic Parameters (Input Fields)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic you want to list parameters for. If omitted, the logic as specified in the product’s master is used, otherwise the passed logic is used |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLogicInputFieldsResponse|error`

**Sample code:**

```ballerina
oas:ListLogicInputFieldsResponse result = check pricefxClient->listLogicParametersInput(uniqueName);
```

</div>
</details>

<details>
<summary>listLogics</summary>

<div>

List Logics

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLogicsResponse|error`

**Sample code:**

```ballerina
oas:ListLogicsResponse result = check pricefxClient->listLogics();
```

</div>
</details>

<details>
<summary>setDefaultPricingLogic</summary>

<div>

Set a Default Pricing Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `uniqueName` | <code>string</code> | Yes | The name (`uniqueName`) of the logic that will be set as default. Leave blank to clear the default pricing logic |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SetDefaultPricingLogicResponse|error`

**Sample code:**

```ballerina
oas:SetDefaultPricingLogicResponse result = check pricefxClient->setDefaultPricingLogic(uniqueName);
```

</div>
</details>

<details>
<summary>syntaxCheck</summary>

<div>

Syntax Check

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SyntaxCheckRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->syntaxCheck(payload);
```

</div>
</details>

<details>
<summary>testLogic</summary>

<div>

Test a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:TestLogicRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:TestLogicEnvelope|error`

**Sample code:**

```ballerina
oas:TestLogicEnvelope result = check pricefxClient->testLogic(payload);
```

</div>
</details>

<details>
<summary>updateLogic</summary>

<div>

Update a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic. The `id` is the `typedId` without the **F** suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.F**  is **2147484837** |
| `payload` | <code>record &#123;record &#123;decimal version?; string typedId?; string uniqueName?; string label?; string validAfter?; string status?; anydata simulationSet?; anydata userGroupEdit?; anydata userGroupViewDetails?; anydata formulaNature?; string lastUpdateByName?; record &#123;decimal version?; string typedId?; string elementName?; string elementLabel?; anydata elementDescription?; string[] elementGroups?; anydata conditionElementName?; boolean hideWarnings?; boolean excludeFromExport?; boolean protectedExpression?; decimal elementTimeout?; decimal displayOptions?; string? formatType?; anydata elementSuffix?; boolean allowOverride?; boolean summarize?; boolean hideOnNull?; anydata userGroup?; anydata cssProperties?; anydata resultGroup?; string combinationType?; boolean storeInAttributeExtension?; anydata criticalAlert?; anydata redAlert?; anydata yellowAlert?; anydata labelTranslations?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?; string formulaExpression?;&#125;[] elements?; record &#123;&#125;[] inputDescriptors?; string formulaType?; anydata createdByName?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:logicResponse|error`

**Sample code:**

```ballerina
oas:logicResponse result = check pricefxClient->updateLogic(id, payload);
```

</div>
</details>

<details>
<summary>updateLogicNo</summary>

<div>

Update a Logic (No syntax check)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic. The `id` is the `typedId` without the **F** suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.F**  is **2147484837** |
| `payload` | <code>record &#123;record &#123;decimal version?; string typedId?; string uniqueName?; string label?; string validAfter?; string status?; anydata simulationSet?; anydata userGroupEdit?; anydata userGroupViewDetails?; anydata formulaNature?; string lastUpdateByName?; record &#123;decimal version?; string typedId?; string elementName?; string elementLabel?; anydata elementDescription?; string[] elementGroups?; anydata conditionElementName?; boolean hideWarnings?; boolean excludeFromExport?; boolean protectedExpression?; decimal elementTimeout?; decimal displayOptions?; string? formatType?; anydata elementSuffix?; boolean allowOverride?; boolean summarize?; boolean hideOnNull?; anydata userGroup?; anydata cssProperties?; anydata resultGroup?; string combinationType?; boolean storeInAttributeExtension?; anydata criticalAlert?; anydata redAlert?; anydata yellowAlert?; anydata labelTranslations?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?; string formulaExpression?;&#125;[] elements?; record &#123;&#125;[] inputDescriptors?; string formulaType?; anydata createdByName?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:logicResponse|error`

**Sample code:**

```ballerina
oas:logicResponse result = check pricefxClient->updateLogicNo(id, payload);
```

</div>
</details>

<details>
<summary>updateLogicPartial</summary>

<div>

Update a Logic (Partial)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The ID of the logic. The `id` is the `typedId` without the **F** suffix. For example, the `id` attribute of the item with `typedId` = **2147484837.F**  is **2147484837** |
| `payload` | <code>record &#123;record &#123;decimal version?; string typedId?; string uniqueName?; string label?; string validAfter?; string status?; anydata simulationSet?; anydata userGroupEdit?; anydata userGroupViewDetails?; anydata formulaNature?; string lastUpdateByName?; record &#123;decimal version?; string typedId?; string elementName?; string elementLabel?; anydata elementDescription?; string[] elementGroups?; anydata conditionElementName?; boolean hideWarnings?; boolean excludeFromExport?; boolean protectedExpression?; decimal elementTimeout?; decimal displayOptions?; string? formatType?; anydata elementSuffix?; boolean allowOverride?; boolean summarize?; boolean hideOnNull?; anydata userGroup?; anydata cssProperties?; anydata resultGroup?; string combinationType?; boolean storeInAttributeExtension?; anydata criticalAlert?; anydata redAlert?; anydata yellowAlert?; anydata labelTranslations?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?; string formulaExpression?;&#125;[] elements?; record &#123;&#125;[] inputDescriptors?; string formulaType?; anydata createdByName?; string createDate?; decimal createdBy?; string lastUpdateDate?; decimal lastUpdateBy?;&#125; data?;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:logicResponse|error`

**Sample code:**

```ballerina
oas:logicResponse result = check pricefxClient->updateLogicPartial(id, payload);
```

</div>
</details>

#### Calculation Grids

<details>
<summary>acceptCalculationGridItem</summary>

<div>

Submit a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Calculation Grid you want to submit items for. You can retrieve the `id` of the CG, for example, by calling the `/fetch/CG` endpoint |
| `payload` | <code>oas:SubmitCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:SubmitCalculationGridItemResponse result = check pricefxClient->acceptCalculationGridItem(id, payload);
```

</div>
</details>

<details>
<summary>addCalculationGrid</summary>

<div>

Add a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:AddCalculationGridResponse result = check pricefxClient->addCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>addCalculationGridItem</summary>

<div>

Add a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:AddCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:AddCalculationGridItemResponse result = check pricefxClient->addCalculationGridItem(keyNumber, payload);
```

</div>
</details>

<details>
<summary>calculateCalculationGrid</summary>

<div>

Calculate a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid you want to calculate |
| `payload` | <code>oas:CalculateCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CalculateCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:CalculateCalculationGridResponse result = check pricefxClient->calculateCalculationGrid(id, payload);
```

</div>
</details>

<details>
<summary>deleteCalculationGrid</summary>

<div>

Delete a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:DeleteCalculationGridResponse result = check pricefxClient->deleteCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>deleteCalculationGridItem</summary>

<div>

Delete a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:DeleteCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:DeleteCalculationGridItemResponse result = check pricefxClient->deleteCalculationGridItem(keyNumber, payload);
```

</div>
</details>

<details>
<summary>getCalculationGrid</summary>

<div>

Get a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | ID of the Calculation Grid you want to retrieve |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:GetCalculationGridResponse result = check pricefxClient->getCalculationGrid(id, payload);
```

</div>
</details>

<details>
<summary>getCalculationGridItem</summary>

<div>

Get a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid Item you want to fetch |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:GetCalculationGridItemResponse result = check pricefxClient->getCalculationGridItem(keyNumber, id, payload);
```

</div>
</details>

<details>
<summary>listCalculationGridItems</summary>

<div>

List Calculation Grid Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `keyNumber` | <code>"1"&#124;"2"&#124;"3"&#124;"4"&#124;"5"&#124;"6"</code> | Yes | Use CGI1..CGI6 in the path, where numbers from 1 to 6 refer to Calculation Grid Item keys |
| `payload` | <code>oas:ListCalculationGridItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculationGridItemsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculationGridItemsResponse result = check pricefxClient->listCalculationGridItems(keyNumber, payload);
```

</div>
</details>

<details>
<summary>listCalculationGrids</summary>

<div>

List Calculation Grids

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListCalculationGridsResponse|error`

**Sample code:**

```ballerina
oas:ListCalculationGridsResponse result = check pricefxClient->listCalculationGrids(payload);
```

</div>
</details>

<details>
<summary>rejectCalculationGridItem</summary>

<div>

Deny a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | The `id` of the Calculation Grid you want to deny items for. You can retrieve the `id` of the CG, for example, by calling the `/fetch/CG` endpoint |
| `payload` | <code>oas:DenyCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DenyCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:DenyCalculationGridItemResponse result = check pricefxClient->rejectCalculationGridItem(id, payload);
```

</div>
</details>

<details>
<summary>updateCalculationGrid</summary>

<div>

Update a Calculation Grid

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateCalculationGridRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCalculationGridResponse|error`

**Sample code:**

```ballerina
oas:UpdateCalculationGridResponse result = check pricefxClient->updateCalculationGrid(payload);
```

</div>
</details>

<details>
<summary>updateCalculationGridItem</summary>

<div>

Update a Calculation Grid Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Calculation Grid Item you want to update |
| `payload` | <code>oas:UpdateCalculationGridItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateCalculationGridItemResponse|error`

**Sample code:**

```ballerina
oas:UpdateCalculationGridItemResponse result = check pricefxClient->updateCalculationGridItem(id, payload);
```

</div>
</details>

#### Action Types

<details>
<summary>addActionType</summary>

<div>

Add an Action Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddActionTypeRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddActionTypeResponse|error`

**Sample code:**

```ballerina
oas:AddActionTypeResponse result = check pricefxClient->addActionType(payload);
```

</div>
</details>

<details>
<summary>deleteActionItemType</summary>

<div>

Delete an Action Item Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;record &#123;string typedId;&#125; data;&#125;</code> | Yes | The general delete request. Deletes the object specified by `typedId` in the request body |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteActionItemTypeResponse|error`

**Sample code:**

```ballerina
oas:DeleteActionItemTypeResponse result = check pricefxClient->deleteActionItemType(payload);
```

</div>
</details>

<details>
<summary>listActionTypes</summary>

<div>

List Action Types

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;int endRow?; record &#123;&#125;? oldValues?; string operationType?; int startRow?; string textMatchStyle?; record &#123;string _constructor?; string operator?; record &#123;string fieldName?; string operator?; string value?;&#125;[] criteria?;&#125; data?;&#125;</code> | Yes | A general fetch request. A filter can be applied |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListActionTypesResponse|error`

**Sample code:**

```ballerina
oas:ListActionTypesResponse result = check pricefxClient->listActionTypes(payload);
```

</div>
</details>

<details>
<summary>updateActionType</summary>

<div>

Update an Action Type

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateAITBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateActionTypeResponse|error`

**Sample code:**

```ballerina
oas:UpdateActionTypeResponse result = check pricefxClient->updateActionType(payload);
```

</div>
</details>

#### Actions

<details>
<summary>createActionItem</summary>

<div>

Create an Action Item + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddActionItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddActionItemResponse|error`

**Sample code:**

```ballerina
oas:AddActionItemResponse result = check pricefxClient->createActionItem(payload);
```

</div>
</details>

<details>
<summary>deleteActionItem</summary>

<div>

Delete an Action Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteActionItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteActionItemResponse|error`

**Sample code:**

```ballerina
oas:DeleteActionItemResponse result = check pricefxClient->deleteActionItem(payload);
```

</div>
</details>

<details>
<summary>executeLogic</summary>

<div>

Execute a Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The `typeCode` of the Action Item you want to execute the calculation for |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteActionItemLogicResponse|error`

**Sample code:**

```ballerina
oas:ExecuteActionItemLogicResponse result = check pricefxClient->executeLogic(typeCode, payload);
```

</div>
</details>

<details>
<summary>listActionItems</summary>

<div>

List Action Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:FetchAIBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListActionItemsResponse|error`

**Sample code:**

```ballerina
oas:ListActionItemsResponse result = check pricefxClient->listActionItems(payload);
```

</div>
</details>

<details>
<summary>updateActionItem</summary>

<div>

Update an Action Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateActionItemRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateActionItemResponse|error`

**Sample code:**

```ballerina
oas:UpdateActionItemResponse result = check pricefxClient->updateActionItem(payload);
```

</div>
</details>

#### Jobs & Tasks

<details>
<summary>cancelJob</summary>

<div>

Cancel a Job

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` if the job you want to cancel |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->cancelJob(id, payload);
```

</div>
</details>

<details>
<summary>listJobs</summary>

<div>

List Jobs

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;int endRow?; record &#123;&#125;? oldValues?; string operationType?; int startRow?; string textMatchStyle?; record &#123;string _constructor?; string operator?; record &#123;string fieldName?; string operator?; string value?;&#125;[] criteria?;&#125; data?;&#125;</code> | Yes | A general fetch request. A filter can be applied |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListJSTResponse|error`

**Sample code:**

```ballerina
oas:ListJSTResponse result = check pricefxClient->listJobs(payload);
```

</div>
</details>

#### Workflow

<details>
<summary>addApproverStep</summary>

<div>

Add an Approver Step

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `currentStepId` | <code>string</code> | Yes | The ID of the workflow step. It can be retrieved using the `/workflowsmanager.fetch/active` (**List Pending Approvals**) endpoint |
| `payload` | <code>oas:AddApproverStepRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddApproverStepResponse|error`

**Sample code:**

```ballerina
oas:AddApproverStepResponse result = check pricefxClient->addApproverStep(currentStepId, payload);
```

</div>
</details>

<details>
<summary>addWatcherStep</summary>

<div>

Add a Watcher Step

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `currentStepId` | <code>string</code> | Yes | The ID of the workflow step. It can be retrieved using the `/workflowsmanager.fetch/active` (**List Pending Approvals**) endpoint |
| `payload` | <code>oas:AddWatcherStepRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddWatcherStepResponse|error`

**Sample code:**

```ballerina
oas:AddWatcherStepResponse result = check pricefxClient->addWatcherStep(currentStepId, payload);
```

</div>
</details>

<details>
<summary>approveDocument</summary>

<div>

Approve a Document

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `currentStepId` | <code>string</code> | Yes | The ID of the workflow step. It can be retrieved using the `/workflowsmanager.fetch/active` (**List Pending Approvals**) endpoint |
| `payload` | <code>oas:ApproveDocumentRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ApproveDocumentResponse|error`

**Sample code:**

```ballerina
oas:ApproveDocumentResponse result = check pricefxClient->approveDocument(currentStepId, payload);
```

</div>
</details>

<details>
<summary>denyDocument</summary>

<div>

Deny a Document

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `currentStepId` | <code>string</code> | Yes | The ID of the workflow step. It can be retrieved using the `/workflowsmanager.fetch/active` (**List Pending Approvals**) endpoint |
| `payload` | <code>oas:DenyDocumentRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DenyDocumentResponse|error`

**Sample code:**

```ballerina
oas:DenyDocumentResponse result = check pricefxClient->denyDocument(currentStepId, payload);
```

</div>
</details>

<details>
<summary>fetchPendingReviews</summary>

<div>

Fetch Pending Reviews

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:FetchPendingReviewsEnvelope|error`

**Sample code:**

```ballerina
oas:FetchPendingReviewsEnvelope result = check pricefxClient->fetchPendingReviews();
```

</div>
</details>

<details>
<summary>getWorkflowDocument</summary>

<div>

Get a Workflow Document

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the approvable object you want to retrieve workflow details for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetWorkflowDocumentResponse|error`

**Sample code:**

```ballerina
oas:GetWorkflowDocumentResponse result = check pricefxClient->getWorkflowDocument(typedId);
```

</div>
</details>

<details>
<summary>listPendingApprovals</summary>

<div>

List Pending Approvals

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListPendingApprovalsResponse|error`

**Sample code:**

```ballerina
oas:ListPendingApprovalsResponse result = check pricefxClient->listPendingApprovals();
```

</div>
</details>

<details>
<summary>listUserSPendingApprovals</summary>

<div>

List User's Pending Approvals

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `loginName` | <code>string</code> | Yes | The login name of the user you want to retrieve Pending Workflows for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUserPendingApprovalsResponse|error`

**Sample code:**

```ballerina
oas:ListUserPendingApprovalsResponse result = check pricefxClient->listUserSPendingApprovals(loginName);
```

</div>
</details>

<details>
<summary>listWorkflows</summary>

<div>

List Workflows

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListWorkflowsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListWorkflowsResponse|error`

**Sample code:**

```ballerina
oas:ListWorkflowsResponse result = check pricefxClient->listWorkflows(payload);
```

</div>
</details>

<details>
<summary>setReviewAsDone</summary>

<div>

Set a Review as Done

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the object to mark as reviewed |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->setReviewAsDone(typedId, payload);
```

</div>
</details>

<details>
<summary>updateReviewStatus</summary>

<div>

Update a Review Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typedId of the object to update |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->updateReviewStatus(typedId, payload);
```

</div>
</details>

<details>
<summary>withdrawDocument</summary>

<div>

Withdraw a Document

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `currentStepId` | <code>string</code> | Yes | The ID of the workflow step. It can be retrieved using the `/workflowsmanager.fetch/active` (**List Pending Approvals**) endpoint |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:WithdrawDocumentResponse|error`

**Sample code:**

```ballerina
oas:WithdrawDocumentResponse result = check pricefxClient->withdrawDocument(currentStepId);
```

</div>
</details>

#### Workflow Delegation

<details>
<summary>createWorkflowDelegation</summary>

<div>

Create a Workflow Delegation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:CreateWorkflowDelegationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:CreateWorkflowDelegationResponse|error`

**Sample code:**

```ballerina
oas:CreateWorkflowDelegationResponse result = check pricefxClient->createWorkflowDelegation(payload);
```

</div>
</details>

<details>
<summary>deactivateWorkflowDelegation</summary>

<div>

Deactivate a Workflow Delegation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeactivateWorkflowDelegationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeactivateWorkflowDelegationResponse|error`

**Sample code:**

```ballerina
oas:DeactivateWorkflowDelegationResponse result = check pricefxClient->deactivateWorkflowDelegation(payload);
```

</div>
</details>

<details>
<summary>deleteWorkflowDelegation</summary>

<div>

Delete a Workflow Delegation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:DeleteWorkflowDelegationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteWorkflowDelegationResponse|error`

**Sample code:**

```ballerina
oas:DeleteWorkflowDelegationResponse result = check pricefxClient->deleteWorkflowDelegation(payload);
```

</div>
</details>

<details>
<summary>listDelegatedWorkflows</summary>

<div>

List Delegated Workflows

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListDelegatedWorkflowsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListDelegatedWorkflowsResponse|error`

**Sample code:**

```ballerina
oas:ListDelegatedWorkflowsResponse result = check pricefxClient->listDelegatedWorkflows(payload);
```

</div>
</details>

<details>
<summary>updateWorkflowDelegation</summary>

<div>

Update a Workflow Delegation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateWorkflowDelegationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateWorkflowDelegationResponse|error`

**Sample code:**

```ballerina
oas:UpdateWorkflowDelegationResponse result = check pricefxClient->updateWorkflowDelegation(payload);
```

</div>
</details>

<details>
<summary>validateWorkflowDelegation</summary>

<div>

Validate a Workflow Delegation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ValidateWorkflowDelegationRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ValidateWorkflowDelegationResponse|error`

**Sample code:**

```ballerina
oas:ValidateWorkflowDelegationResponse result = check pricefxClient->validateWorkflowDelegation(payload);
```

</div>
</details>

#### Notifications

<details>
<summary>deleteNotification</summary>

<div>

Delete a Notification

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationSetreadBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteNotificationEnvelope|error`

**Sample code:**

```ballerina
oas:DeleteNotificationEnvelope result = check pricefxClient->deleteNotification(payload);
```

</div>
</details>

<details>
<summary>listNotifications</summary>

<div>

List Notifications

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationListBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListNotificationsEnvelope|error`

**Sample code:**

```ballerina
oas:ListNotificationsEnvelope result = check pricefxClient->listNotifications(payload);
```

</div>
</details>

<details>
<summary>markAsRead</summary>

<div>

Mark as Read

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->markAsRead(payload);
```

</div>
</details>

<details>
<summary>sendValidationMessage</summary>

<div>

Send a Validation Message

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationSendBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->sendValidationMessage(payload);
```

</div>
</details>

#### Internationalization

<details>
<summary>addNewInternationalizationMessage</summary>

<div>

Add a New Internationalization Message + payload -

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:I18nmanagerPutBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AddInternationalizationMessageEnvelope|error`

**Sample code:**

```ballerina
oas:AddInternationalizationMessageEnvelope result = check pricefxClient->addNewInternationalizationMessage(payload);
```

</div>
</details>

<details>
<summary>deleteInternationalizationMessages</summary>

<div>

Delete Internationalization Messages

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:I18nmanagerDeleteKeysBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->deleteInternationalizationMessages(payload);
```

</div>
</details>

<details>
<summary>listInternationalizationMessages</summary>

<div>

List Internationalization Messages

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:I18nmanagerFetchWithExtraDataBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListInternationalizationMessagesEnvelope|error`

**Sample code:**

```ballerina
oas:ListInternationalizationMessagesEnvelope result = check pricefxClient->listInternationalizationMessages(payload);
```

</div>
</details>

#### Clicmanager

<details>
<summary>addLineItems</summary>

<div>

Add Line Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | typed ID of the target CLIC document |
| `payload` | <code>oas:ClicmanagerAdditemstypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `record`

**Sample code:**

```ballerina
record result = check pricefxClient->addLineItems(typedId, payload);
```

</div>
</details>

<details>
<summary>fetchActivities</summary>

<div>

Fetch Activities

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ActivitylogFetchBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `record`

**Sample code:**

```ballerina
record result = check pricefxClient->fetchActivities(payload);
```

</div>
</details>

<details>
<summary>getClicHeader</summary>

<div>

Get a Quote/Contract/Rebate Agreement/Compensation Plan Header

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Contract, Quote, or Rebate Agreement you want to return details for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetQuoteContractRebateAgreementResponse|error`

**Sample code:**

```ballerina
oas:GetQuoteContractRebateAgreementResponse result = check pricefxClient->getClicHeader(typedId);
```

</div>
</details>

<details>
<summary>importClicLineItems</summary>

<div>

Import Line Items (w/o Input Types)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:ClicmanagerImportlineitemstypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ClicOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ClicOperationEnvelope result = check pricefxClient->importClicLineItems(typedId, payload);
```

</div>
</details>

<details>
<summary>listClicObjects</summary>

<div>

List CLIC Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Quote/Contract/Rebate Agreement/Compensation Plan you want to retrieve line items for |
| `payload` | <code>oas:GetCLICrequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListClicObjectsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:GetCLICresponse|error`

**Sample code:**

```ballerina
oas:GetCLICresponse result = check pricefxClient->listClicObjects(typedId, payload, queries);
```

</div>
</details>

<details>
<summary>listUniqueClicItems</summary>

<div>

List Unique CLIC Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListUniqueCLICItemsResponse|error`

**Sample code:**

```ballerina
oas:ListUniqueCLICItemsResponse result = check pricefxClient->listUniqueClicItems(typedId, payload);
```

</div>
</details>

<details>
<summary>removeAllClicLineItems</summary>

<div>

Delete All Line Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the object you want to remove all line items from |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ClicOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ClicOperationEnvelope result = check pricefxClient->removeAllClicLineItems(typedId, payload);
```

</div>
</details>

<details>
<summary>sendEmail</summary>

<div>

Send an Email

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:SendEmailRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->sendEmail(payload);
```

</div>
</details>

<details>
<summary>setClicLostReason</summary>

<div>

Mark an Offer as Lost (with reason)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the Quote you want set as lost |
| `payload` | <code>oas:MarkOfferLostWithReasonRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SetClicLostReasonEnvelope|error`

**Sample code:**

```ballerina
oas:SetClicLostReasonEnvelope result = check pricefxClient->setClicLostReason(typedId, payload);
```

</div>
</details>

<details>
<summary>submitClic</summary>

<div>

Submit a Quote/Contract/Rebate Agreement

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Contract, Quote, or Rebate Agreement you want to submit |
| `payload` | <code>oas:SubmitQuoteContractRebateAgreementRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SubmitQuoteContractRebateAgreementResponse|error`

**Sample code:**

```ballerina
oas:SubmitQuoteContractRebateAgreementResponse result = check pricefxClient->submitClic(typedId, payload);
```

</div>
</details>

<details>
<summary>updateClicLineItems</summary>

<div>

Update CLIC Line Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the CLIC object (e.g., a Quote) you want to update line items for |
| `payload` | <code>oas:UpdateCLICLineItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpdateClicLineItemsEnvelope|error`

**Sample code:**

```ballerina
oas:UpdateClicLineItemsEnvelope result = check pricefxClient->updateClicLineItems(typedId, payload);
```

</div>
</details>

#### Advanced Configuration Options

<details>
<summary>getAdvancedConfigurationProperty</summary>

<div>

Get Advanced Configuration Property

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `propertyname` | <code>string</code> | Yes | Name of the configuration property to retrieve |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:AdvancedConfigPropertyEnvelope|error`

**Sample code:**

```ballerina
oas:AdvancedConfigPropertyEnvelope result = check pricefxClient->getAdvancedConfigurationProperty(propertyname);
```

</div>
</details>

#### Admin Tools

<details>
<summary>changeTermsOfUse</summary>

<div>

changeTermsOfUse

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AccountmanagerChangetermsofuseBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No |  |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->changeTermsOfUse(payload);
```

</div>
</details>

<details>
<summary>pingWithout</summary>

<div>

Ping (without authentication)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->pingWithout();
```

</div>
</details>

#### Configuration

<details>
<summary>getExternalApplicationProperties</summary>

<div>

Get External Application Properties

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetexternalapppropertiesResponse|error`

**Sample code:**

```ballerina
oas:GetexternalapppropertiesResponse result = check pricefxClient->getExternalApplicationProperties();
```

</div>
</details>

#### Visual Configuration

<details>
<summary>addConfigurationStorage</summary>

<div>

Add a Configuration Storage

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:AddJCSBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConfigurationStorageOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConfigurationStorageOperationEnvelope result = check pricefxClient->addConfigurationStorage(payload);
```

</div>
</details>

<details>
<summary>deleteConfigurationStorage</summary>

<div>

Delete a Configuration Storage

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConfigurationStorageOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConfigurationStorageOperationEnvelope result = check pricefxClient->deleteConfigurationStorage(payload);
```

</div>
</details>

<details>
<summary>deployConfigurationStorage</summary>

<div>

Deploy a Configuration Storage

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:JcsmanagerDeployBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConfigurationStorageOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConfigurationStorageOperationEnvelope result = check pricefxClient->deployConfigurationStorage(payload);
```

</div>
</details>

<details>
<summary>getConfigurationStorage</summary>

<div>

Get a Configuration Storage

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:FetchJCSBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetConfigurationStorageEnvelope|error`

**Sample code:**

```ballerina
oas:GetConfigurationStorageEnvelope result = check pricefxClient->getConfigurationStorage(payload);
```

</div>
</details>

<details>
<summary>updateConfigurationStorage</summary>

<div>

Update a Configuration Storage

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:UpdateJCSBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ConfigurationStorageOperationEnvelope|error`

**Sample code:**

```ballerina
oas:ConfigurationStorageOperationEnvelope result = check pricefxClient->updateConfigurationStorage(payload);
```

</div>
</details>

#### Metadata

<details>
<summary>listAttributeFieldsMetadata</summary>

<div>

List Attribute Fields' Metadata

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"ACTT"&#124;"AI"&#124;"AP"&#124;"APIK"&#124;"BD"&#124;"BPT"&#124;"BR"&#124;"C"&#124;"CA"&#124;"CAM"&#124;"CDESC"&#124;"CF"&#124;"CFS"&#124;"CFT"&#124;"CH"&#124;"CL"&#124;"CLLI"&#124;"CLLIAM"&#124;"CLR"&#124;"CLT"&#124;"CN"&#124;"CO"&#124;"COAM"&#124;"COCT"&#124;"COCTAM"&#124;"COHT"&#124;"COHTAM"&#124;"COLI"&#124;"COR"&#124;"CORAM"&#124;"COROLI"&#124;"CORS"&#124;"CORSC"&#124;"COT"&#124;"CS"&#124;"CT"&#124;"CTAM"&#124;"CTLI"&#124;"CTMU"&#124;"CTMUI"&#124;"CTT"&#124;"CTTAM"&#124;"CTTREE"&#124;"CW"&#124;"CX10"&#124;"CX20"&#124;"CX3"&#124;"CX30"&#124;"CX50"&#124;"CX6"&#124;"CX8"&#124;"CXAM"&#124;"DA"&#124;"DB"&#124;"DCR"&#124;"DCRAM"&#124;"DCRI"&#124;"DCRL"&#124;"DCRMC"&#124;"DCRT"&#124;"DE"&#124;"DI"&#124;"DM"&#124;"DMDC"&#124;"DMDL"&#124;"DMDS"&#124;"DMF"&#124;"DMM"&#124;"DMR"&#124;"DMT"&#124;"DP"&#124;"DPR"&#124;"DPT"&#124;"DREF"&#124;"DREG"&#124;"EDL"&#124;"ET"&#124;"EVT"&#124;"F"&#124;"FE"&#124;"FN"&#124;"HEVT"&#124;"HRT"&#124;"HRTAM"&#124;"IDC"&#124;"IE"&#124;"ISH"&#124;"JLTV"&#124;"JLTV2"&#124;"JLTVM"&#124;"JST"&#124;"LAT"&#124;"LT"&#124;"LTT"&#124;"LTV"&#124;"M"&#124;"MC"&#124;"MLTV"&#124;"MLTV2"&#124;"MLTV3"&#124;"MLTV4"&#124;"MLTV5"&#124;"MLTV6"&#124;"MLTVM"&#124;"MN"&#124;"MO"&#124;"MPL"&#124;"MPLAM"&#124;"MPLI"&#124;"MPLIT"&#124;"MPLT"&#124;"MR"&#124;"MRAM"&#124;"MT"&#124;"NT"&#124;"P"&#124;"PAM"&#124;"PBOME"&#124;"PCOMP"&#124;"PCOMPCO"&#124;"PCW"&#124;"PDESC"&#124;"PG"&#124;"PGI"&#124;"PGIM"&#124;"PGT"&#124;"PH"&#124;"PL"&#124;"PLI"&#124;"PLIM"&#124;"PLPGTT"&#124;"PLT"&#124;"PR"&#124;"PRAM"&#124;"PREF"&#124;"PT"&#124;"PWH"&#124;"PX10"&#124;"PX20"&#124;"PX3"&#124;"PX30"&#124;"PX50"&#124;"PX6"&#124;"PX8"&#124;"PXAM"&#124;"PXREF"&#124;"PYR"&#124;"PYRAM"&#124;"Q"&#124;"QAM"&#124;"QLI"&#124;"QMU"&#124;"QMUI"&#124;"QT"&#124;"QTT"&#124;"QTTAM"&#124;"R"&#124;"RAT"&#124;"RATM"&#124;"RBA"&#124;"RBAAM"&#124;"RBALI"&#124;"RBAROLI"&#124;"RBAT"&#124;"RBT"&#124;"RBTAM"&#124;"RR"&#124;"RRAM"&#124;"RRS"&#124;"RRSC"&#124;"RT"&#124;"SAT"&#124;"SC"&#124;"SCN"&#124;"SCNAM"&#124;"SCT"&#124;"SIAM"&#124;"SIM"&#124;"SIMI"&#124;"SL"&#124;"SLAM"&#124;"SX10"&#124;"SX20"&#124;"SX3"&#124;"SX30"&#124;"SX50"&#124;"SX6"&#124;"SX8"&#124;"SXAM"&#124;"TFA"&#124;"TODO"&#124;"U"&#124;"UG"&#124;"US"&#124;"W"&#124;"WD"&#124;"WF"&#124;"WFE"&#124;"XPGI"&#124;"XPLI"&#124;"XSIMI"</code> | Yes | Enter the type code of the entity you want to retrieve information for. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListAttributeFieldsMetadataQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ListAttributeFieldsMetadata|error`

**Sample code:**

```ballerina
oas:ListAttributeFieldsMetadata result = check pricefxClient->listAttributeFieldsMetadata(typeCode, queries);
```

</div>
</details>

<details>
<summary>listEntityFields</summary>

<div>

List Entity Fields

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"ACTT"&#124;"AI"&#124;"AP"&#124;"APIK"&#124;"BD"&#124;"BPT"&#124;"BR"&#124;"C"&#124;"CA"&#124;"CAM"&#124;"CDESC"&#124;"CF"&#124;"CFS"&#124;"CFT"&#124;"CH"&#124;"CL"&#124;"CLLI"&#124;"CLLIAM"&#124;"CLR"&#124;"CLT"&#124;"CN"&#124;"CO"&#124;"COAM"&#124;"COCT"&#124;"COCTAM"&#124;"COHT"&#124;"COHTAM"&#124;"COLI"&#124;"COR"&#124;"CORAM"&#124;"COROLI"&#124;"CORS"&#124;"CORSC"&#124;"COT"&#124;"CS"&#124;"CT"&#124;"CTAM"&#124;"CTLI"&#124;"CTMU"&#124;"CTMUI"&#124;"CTT"&#124;"CTTAM"&#124;"CTTREE"&#124;"CW"&#124;"CX10"&#124;"CX20"&#124;"CX3"&#124;"CX30"&#124;"CX50"&#124;"CX6"&#124;"CX8"&#124;"CXAM"&#124;"DA"&#124;"DB"&#124;"DCR"&#124;"DCRAM"&#124;"DCRI"&#124;"DCRL"&#124;"DCRMC"&#124;"DCRT"&#124;"DE"&#124;"DI"&#124;"DM"&#124;"DMDC"&#124;"DMDL"&#124;"DMDS"&#124;"DMF"&#124;"DMM"&#124;"DMR"&#124;"DMT"&#124;"DP"&#124;"DPR"&#124;"DPT"&#124;"DREF"&#124;"DREG"&#124;"EDL"&#124;"ET"&#124;"EVT"&#124;"F"&#124;"FE"&#124;"FN"&#124;"HEVT"&#124;"HRT"&#124;"HRTAM"&#124;"IDC"&#124;"IE"&#124;"ISH"&#124;"JLTV"&#124;"JLTV2"&#124;"JLTVM"&#124;"JST"&#124;"LAT"&#124;"LT"&#124;"LTT"&#124;"LTV"&#124;"M"&#124;"MC"&#124;"MLTV"&#124;"MLTV2"&#124;"MLTV3"&#124;"MLTV4"&#124;"MLTV5"&#124;"MLTV6"&#124;"MLTVM"&#124;"MN"&#124;"MO"&#124;"MPL"&#124;"MPLAM"&#124;"MPLI"&#124;"MPLIT"&#124;"MPLT"&#124;"MR"&#124;"MRAM"&#124;"MT"&#124;"NT"&#124;"P"&#124;"PAM"&#124;"PBOME"&#124;"PCOMP"&#124;"PCOMPCO"&#124;"PCW"&#124;"PDESC"&#124;"PG"&#124;"PGI"&#124;"PGIM"&#124;"PGT"&#124;"PH"&#124;"PL"&#124;"PLI"&#124;"PLIM"&#124;"PLPGTT"&#124;"PLT"&#124;"PR"&#124;"PRAM"&#124;"PREF"&#124;"PT"&#124;"PWH"&#124;"PX10"&#124;"PX20"&#124;"PX3"&#124;"PX30"&#124;"PX50"&#124;"PX6"&#124;"PX8"&#124;"PXAM"&#124;"PXREF"&#124;"PYR"&#124;"PYRAM"&#124;"Q"&#124;"QAM"&#124;"QLI"&#124;"QMU"&#124;"QMUI"&#124;"QT"&#124;"QTT"&#124;"QTTAM"&#124;"R"&#124;"RAT"&#124;"RATM"&#124;"RBA"&#124;"RBAAM"&#124;"RBALI"&#124;"RBAROLI"&#124;"RBAT"&#124;"RBT"&#124;"RBTAM"&#124;"RR"&#124;"RRAM"&#124;"RRS"&#124;"RRSC"&#124;"RT"&#124;"SAT"&#124;"SC"&#124;"SCN"&#124;"SCNAM"&#124;"SCT"&#124;"SIAM"&#124;"SIM"&#124;"SIMI"&#124;"SL"&#124;"SLAM"&#124;"SX10"&#124;"SX20"&#124;"SX3"&#124;"SX30"&#124;"SX50"&#124;"SX6"&#124;"SX8"&#124;"SXAM"&#124;"TFA"&#124;"TODO"&#124;"U"&#124;"UG"&#124;"US"&#124;"W"&#124;"WD"&#124;"WF"&#124;"WFE"&#124;"XPGI"&#124;"XPLI"&#124;"XSIMI"</code> | Yes | Enter the type code of the entity you want to retrieve information for. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:ListEntityFieldsQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ListEntityFieldsResponse|error`

**Sample code:**

```ballerina
oas:ListEntityFieldsResponse result = check pricefxClient->listEntityFields(typeCode, queries);
```

</div>
</details>

#### General

<details>
<summary>deleteColumnValues</summary>

<div>

Delete Column Values

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The object's type code. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) |
| `columnName` | <code>string</code> | Yes | The name of the column/attribute you want to remove values from |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteColumnValuesResponse|error`

**Sample code:**

```ballerina
oas:DeleteColumnValuesResponse result = check pricefxClient->deleteColumnValues(typeCode, columnName);
```

</div>
</details>

<details>
<summary>deleteObjects</summary>

<div>

Delete Objects

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The object's type code. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) |
| `payload` | <code>oas:DeleteObjectsForceFilterRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:DeleteObjectsResponse|error`

**Sample code:**

```ballerina
oas:DeleteObjectsResponse result = check pricefxClient->deleteObjects(typeCode, payload);
```

</div>
</details>

<details>
<summary>getQueryApiMetadata</summary>

<div>

Get Query API Metadata

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:QueryapiExecuteBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:QueryApiMetadataEnvelope|error`

**Sample code:**

```ballerina
oas:QueryApiMetadataEnvelope result = check pricefxClient->getQueryApiMetadata(payload);
```

</div>
</details>

<details>
<summary>insertBulkData</summary>

<div>

Insert Bulk Data

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>oas:TypeCodeEnum</code> | Yes | Specify the type code for the entity you want to work with. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article.' |
| `payload` | <code>oas:InsertBulkDataRequest</code> | Yes | The **`/loaddata/P`** endpoint (Insert Bulk Products) is used in our example.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:loaddataResponse|error`

**Sample code:**

```ballerina
oas:loaddataResponse result = check pricefxClient->insertBulkData(typeCode, payload);
```

</div>
</details>

<details>
<summary>insertBulkDataFromFile</summary>

<div>

Insert Bulk Data From a File

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"C"&#124;"CDESC"&#124;"CX"&#124;"JLTV"&#124;"LTV"&#124;"MLTV"&#124;"P"&#124;"PBOME"&#124;"PCOMP"&#124;"PDESC"&#124;"PR"&#124;"PX"&#124;"PXREF"&#124;"SL"&#124;"SX"&#124;"TODO"&#124;"UG"</code> | Yes | Enter the type code of the entity you want to insert a data to. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article |
| `payload` | <code>oas:InsertBulkDataFromFileRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:InsertBulkDataFromFileQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:InsertBulkDataFromFileResponse|error`

**Sample code:**

```ballerina
oas:InsertBulkDataFromFileResponse result = check pricefxClient->insertBulkDataFromFile(typeCode, payload, queries);
```

</div>
</details>

<details>
<summary>insertBulkDataFromFileAsync</summary>

<div>

Insert Bulk Data From a File (async)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"C"&#124;"CDESC"&#124;"CX"&#124;"JLTV"&#124;"LTV"&#124;"MLTV"&#124;"P"&#124;"PBOME"&#124;"PCOMP"&#124;"PDESC"&#124;"PR"&#124;"PX"&#124;"PXREF"&#124;"SL"&#124;"SX"&#124;"TODO"&#124;"UG"</code> | Yes | Enter the type code of the entity you want to insert a data to. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article |
| `payload` | <code>oas:InsertBulkDataFromFileAsyncRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:InsertBulkDataFromFileAsyncQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:InsertBulkDataFromFileAsyncResponse|error`

**Sample code:**

```ballerina
oas:InsertBulkDataFromFileAsyncResponse result = check pricefxClient->insertBulkDataFromFileAsync(typeCode, payload, queries);
```

</div>
</details>

<details>
<summary>listTypeCodes</summary>

<div>

List Type Codes

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:typecodesResponse|error?`

**Sample code:**

```ballerina
oas:typecodesResponse|error? result = check pricefxClient->listTypeCodes();
```

</div>
</details>

<details>
<summary>massUpdate</summary>

<div>

Mass Update

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The object's type code. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) |
| `payload` | <code>oas:MassUpdateRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:MassUpdateResponse|error`

**Sample code:**

```ballerina
oas:MassUpdateResponse result = check pricefxClient->massUpdate(typeCode, payload);
```

</div>
</details>

<details>
<summary>queryApiExecute</summary>

<div>

Query API Execute

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:QueryapiExecuteBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:QueryApiExecuteQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:QueryApiExecuteEnvelope|error`

**Sample code:**

```ballerina
oas:QueryApiExecuteEnvelope result = check pricefxClient->queryApiExecute(payload, queries);
```

</div>
</details>

<details>
<summary>updateObject</summary>

<div>

Update an Object

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The object's type code. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) |
| `payload` | <code>oas:UpdateObjectRequest</code> | Yes | &lt;!-- theme: warning --&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->updateObject(typeCode, payload);
```

</div>
</details>

<details>
<summary>updateObjectReturningOldData</summary>

<div>

Update an Object (and return old data)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>string</code> | Yes | The object's type code. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) |
| `payload` | <code>oas:UpdateObjectReturnOldDataRequest</code> | Yes | &lt;!-- theme: warning --&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `error?`

**Sample code:**

```ballerina
error? result = check pricefxClient->updateObjectReturningOldData(typeCode, payload);
```

</div>
</details>

<details>
<summary>upsertObject</summary>

<div>

Upsert an Object

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>"ACTT"&#124;"AP"&#124;"APIK"&#124;"BD"&#124;"BPT"&#124;"BR"&#124;"C"&#124;"CA"&#124;"CAM"&#124;"CDESC"&#124;"CF"&#124;"CFS"&#124;"CFT"&#124;"CH"&#124;"CLLI"&#124;"CN"&#124;"CS"&#124;"CT"&#124;"CTAM"&#124;"CTLI"&#124;"CTMU"&#124;"CTMUI"&#124;"CTT"&#124;"CTTAM"&#124;"CTTREE"&#124;"CW"&#124;"CX"&#124;"CXAM"&#124;"DA"&#124;"DB"&#124;"DCR"&#124;"DCRAM"&#124;"DCRI"&#124;"DCRL"&#124;"DCRMC"&#124;"DCRT"&#124;"DE"&#124;"DI"&#124;"DM"&#124;"DMDC"&#124;"DMDL"&#124;"DMDS"&#124;"DMF"&#124;"DMM"&#124;"DMR"&#124;"DMT"&#124;"DREG"&#124;"DWT"&#124;"ET"&#124;"EVT"&#124;"F"&#124;"FE"&#124;"FN"&#124;"IDC"&#124;"IE"&#124;"ISH"&#124;"JST"&#124;"JLTV"&#124;"JLTVM"&#124;"LAT"&#124;"LT"&#124;"LTT"&#124;"LTV"&#124;"M"&#124;"MLTV"&#124;"MLTV2"&#124;"MLTV3"&#124;"MLTV4"&#124;"MLTV5"&#124;"MLTV6"&#124;"MLTVM"&#124;"MPL"&#124;"MPLAM"&#124;"MPLI"&#124;"MPLIT"&#124;"MPLT"&#124;"MR"&#124;"MRAM"&#124;"MT"&#124;"P"&#124;"PAM"&#124;"PAPIJ"&#124;"PBOME"&#124;"PCOMP"&#124;"PCW"&#124;"PDESC"&#124;"PG"&#124;"PGI"&#124;"PGIM"&#124;"PGT"&#124;"PH"&#124;"PL"&#124;"PLI"&#124;"PLIM"&#124;"PLT"&#124;"PR"&#124;"PRAM"&#124;"PREF"&#124;"PT"&#124;"PWH"&#124;"PX"&#124;"PXAM"&#124;"PXREF"&#124;"PYR"&#124;"PYRAM"&#124;"Q"&#124;"QAM"&#124;"QLI"&#124;"QMU"&#124;"QMUI"&#124;"QT"&#124;"QTT"&#124;"QTTAM"&#124;"R"&#124;"RAT"&#124;"RATM"&#124;"RBA"&#124;"RBAAM"&#124;"RBALI"&#124;"RBAT"&#124;"RBT"&#124;"RBTAM"&#124;"RR"&#124;"RRAM"&#124;"RRS"&#124;"RRSC"&#124;"RT"&#124;"SAT"&#124;"SC"&#124;"SCN"&#124;"SCNAM"&#124;"SCT"&#124;"SIAM"&#124;"SIM"&#124;"SIMI"&#124;"TFA"&#124;"TODO"&#124;"U"&#124;"UG"&#124;"US"&#124;"W"&#124;"WD"&#124;"WF"&#124;"WFE"&#124;"XPGI"&#124;"XPLI"&#124;"XSIMI"</code> | Yes | Enter the Type code of the entity you want to insert a data to. See [the list of Type codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article |
| `payload` | <code>oas:UpsertObjectRequest</code> | Yes | The **`/integrate/P`** endpoint (Upsert a Product) is used in our example.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:productResponse|error`

**Sample code:**

```ballerina
oas:productResponse result = check pricefxClient->upsertObject(typeCode, payload);
```

</div>
</details>

<details>
<summary>upsertObjectReturningOldData</summary>

<div>

Upsert an Object (and return old data)

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typeCode` | <code>oas:TypeCodeEnum</code> | Yes | Specify the type code for the entity you want to work with. See [the list of Type Codes](https://pricefx.atlassian.net/wiki/spaces/KB/pages/99570616/Type+Codes) in the Pricefx Knowledge Base article.' |
| `payload` | <code>oas:UpsertObjectReturnOldDataRequest</code> | Yes | The **`/integrate/P/returnolddata`** endpoint (upserts a product) is used in our example.&lt;p&gt; |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:UpsertObjectReturnOldDataResponse|error`

**Sample code:**

```ballerina
oas:UpsertObjectReturnOldDataResponse result = check pricefxClient->upsertObjectReturningOldData(typeCode, payload);
```

</div>
</details>

#### Optimization

<details>
<summary>calculateModelObjectStep</summary>

<div>

Calculate a Model Object Step

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to recalculate the step for |
| `stepName` | <code>"definition"&#124;"configuration"&#124;"results"&#124;"projections"&#124;"parallel"</code> | Yes | Enter the name of the step you want to calculate |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:CalculateModelObjectStepQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:ModelCalculationStepEnvelope|error`

**Sample code:**

```ballerina
oas:ModelCalculationStepEnvelope result = check pricefxClient->calculateModelObjectStep(typedId, stepName, queries);
```

</div>
</details>

<details>
<summary>cancelCalculationStep</summary>

<div>

Cancel a Calculation Step

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to cancel the calculation step for |
| `stepName` | <code>string</code> | Yes | The name of the step you want to cancel |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:JobStatusTrackerResponse|error`

**Sample code:**

```ballerina
oas:JobStatusTrackerResponse result = check pricefxClient->cancelCalculationStep(typedId, stepName);
```

</div>
</details>

<details>
<summary>duplicateModel</summary>

<div>

Duplicate a Model

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes |  |
| `payload` | <code>oas:OptimizationModelduplicatetypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ModelDuplicationEnvelope|error`

**Sample code:**

```ballerina
oas:ModelDuplicationEnvelope result = check pricefxClient->duplicateModel(typedId, payload);
```

</div>
</details>

<details>
<summary>executeModelLogic</summary>

<div>

Execute a Model Logic

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to execute the logic for |
| `stepName` | <code>string</code> | Yes | The name of the step you want to execute the logic for |
| `formulaName` | <code>string</code> | Yes | The name of the logic you want to execute |
| `payload` | <code>oas:ExecuteModelLogicRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ExecuteModelLogicResponse|error`

**Sample code:**

```ballerina
oas:ExecuteModelLogicResponse result = check pricefxClient->executeModelLogic(typedId, stepName, formulaName, payload);
```

</div>
</details>

<details>
<summary>exportModels</summary>

<div>

Export Models

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:OptimizationModelexportBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->exportModels(payload);
```

</div>
</details>

<details>
<summary>getCalculationStatus</summary>

<div>

Get a Calculation Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to retrieve the calculation status for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:JobStatusTrackerResponse|error`

**Sample code:**

```ballerina
oas:JobStatusTrackerResponse result = check pricefxClient->getCalculationStatus(typedId);
```

</div>
</details>

<details>
<summary>getParallelCalculationItem</summary>

<div>

Get a Parallel Calculation Item

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `id` | <code>string</code> | Yes | `id` of the Parallel Calculation Item (PCI) you want to retrieve |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:GetParallelCalculationItemResponse|error`

**Sample code:**

```ballerina
oas:GetParallelCalculationItemResponse result = check pricefxClient->getParallelCalculationItem(id, payload);
```

</div>
</details>

<details>
<summary>getStepCalculationStatus</summary>

<div>

Get a Step Calculation Status

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to retrieve the calculation status for |
| `stepName` | <code>string</code> | Yes | The name of the step you want to calculate |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:JobStatusTrackerResponse|error`

**Sample code:**

```ballerina
oas:JobStatusTrackerResponse result = check pricefxClient->getStepCalculationStatus(typedId, stepName);
```

</div>
</details>

<details>
<summary>importModels</summary>

<div>

Import Models

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:OptimizationModelimportBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ModelDuplicationEnvelope|error`

**Sample code:**

```ballerina
oas:ModelDuplicationEnvelope result = check pricefxClient->importModels(payload);
```

</div>
</details>

<details>
<summary>listModelLogicParameters</summary>

<div>

List Model Logic Parameters

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to retrieve logic parameters for |
| `stepName` | <code>string</code> | Yes | The name of the step you want to list logic parameters for |
| `formulaName` | <code>string</code> | Yes | The name of the logic you want to get parameters for |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListModelLogicParametersResponse|error`

**Sample code:**

```ballerina
oas:ListModelLogicParametersResponse result = check pricefxClient->listModelLogicParameters(typedId, stepName, formulaName);
```

</div>
</details>

<details>
<summary>listParallelCalculationItems</summary>

<div>

List Parallel Calculation Items

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:ListParallelCalculationItemsRequest</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListParallelCalculationItemsResponse|error`

**Sample code:**

```ballerina
oas:ListParallelCalculationItemsResponse result = check pricefxClient->listParallelCalculationItems(payload);
```

</div>
</details>

<details>
<summary>loadDataIntoFieldCollection</summary>

<div>

Load Data Into FieldCollection

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | Specifies the typedId (format: `&#123;id&#125;.&#123;type&#125;`) of the FieldCollection to load data into. Type must be either `DMDS` or `DMT` |
| `payload` | <code>oas:DatamartLoadfctypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `http:Response|error`

**Sample code:**

```ballerina
http:Response result = check pricefxClient->loadDataIntoFieldCollection(typedId, payload);
```

</div>
</details>

<details>
<summary>recalculateCalculationOfStep</summary>

<div>

Recalculate a Calculation of a Step

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to recalculate the step for |
| `stepName` | <code>"definition"&#124;"configuration"&#124;"results"&#124;"projections"&#124;"parallel"</code> | Yes | Enter the name of the step you want to calculate |
| `calcName` | <code>string</code> | Yes | The name of the calculation you want to recalculate |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RecalculateCalculationOfStepResponse|error`

**Sample code:**

```ballerina
oas:RecalculateCalculationOfStepResponse result = check pricefxClient->recalculateCalculationOfStep(typedId, stepName, calcName, payload);
```

</div>
</details>

<details>
<summary>recalculateItemsOfParallelCalculation</summary>

<div>

Recalculate Items of a Parallel Calculation

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to recalculate the step for |
| `stepName` | <code>"definition"&#124;"configuration"&#124;"results"&#124;"projections"&#124;"parallel"</code> | Yes | Enter the name of the step you want to calculate |
| `calcName` | <code>string</code> | Yes | The name of the calculation you want to recalculate |
| `payload` | <code>oas:CalcNameItemBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ParallelCalculationEnvelope|error`

**Sample code:**

```ballerina
oas:ParallelCalculationEnvelope result = check pricefxClient->recalculateItemsOfParallelCalculation(typedId, stepName, calcName, payload);
```

</div>
</details>

<details>
<summary>revokeModel</summary>

<div>

Revoke a Model

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | `typedId` of the model you want to revoke |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:RevokeModelResponse|error`

**Sample code:**

```ballerina
oas:RevokeModelResponse result = check pricefxClient->revokeModel(typedId, payload);
```

</div>
</details>

<details>
<summary>saveModel</summary>

<div>

Save a Model

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to save |
| `stepName` | <code>"definition"&#124;"configuration"&#124;"results"&#124;"projections"</code> | Yes | Enter the name of the step you want to save. Steps are defined in the Model Class that is associated to the Model Object |
| `payload` | <code>oas:SaveModelRequest</code> | Yes | The `data` property can only contain the `state` field, all the rest fields will be ignored (and cannot be updated even with update/MO endpoint) |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveModelResponse|error`

**Sample code:**

```ballerina
oas:SaveModelResponse result = check pricefxClient->saveModel(typedId, stepName, payload);
```

</div>
</details>

<details>
<summary>submitModel</summary>

<div>

Submit a Model

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `typedId` | <code>string</code> | Yes | The `typedId` of the Model Object you want to submit |
| `payload` | <code>record &#123;&#125;</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:SaveModelResponse|error`

**Sample code:**

```ballerina
oas:SaveModelResponse result = check pricefxClient->submitModel(typedId, payload);
```

</div>
</details>

<details>
<summary>updateJobStatusTrackerEntry</summary>

<div>

Update Job Status Tracker Entry

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:OptimizationUpdatejstBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:JobStatusTrackerUpdateEnvelope|error`

**Sample code:**

```ballerina
oas:JobStatusTrackerUpdateEnvelope result = check pricefxClient->updateJobStatusTrackerEntry(payload);
```

</div>
</details>

#### Logs

<details>
<summary>getLokiLog</summary>

<div>

Get a Loki Log

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |
| `queries` | <code>*oas:GetLokiLogQueries</code> | Yes | Queries to be sent with the request |

**Returns:** `oas:LokiLogEnvelope|error`

**Sample code:**

```ballerina
oas:LokiLogEnvelope result = check pricefxClient->getLokiLog(queries);
```

</div>
</details>

<details>
<summary>listEmailTasks</summary>

<div>

List Email Tasks

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationListBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListEmailTasksEnvelope|error`

**Sample code:**

```ballerina
oas:ListEmailTasksEnvelope result = check pricefxClient->listEmailTasks(payload);
```

</div>
</details>

<details>
<summary>listEventTasks</summary>

<div>

List Event Tasks

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationListBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListEventTasksEnvelope|error`

**Sample code:**

```ballerina
oas:ListEventTasksEnvelope result = check pricefxClient->listEventTasks(payload);
```

</div>
</details>

<details>
<summary>listLogins</summary>

<div>

List Logins

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:BdmanagerListtypedIdBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListLoginsEnvelope|error`

**Sample code:**

```ballerina
oas:ListLoginsEnvelope result = check pricefxClient->listLogins(payload);
```

</div>
</details>

<details>
<summary>listSecurityConfigurationEvents</summary>

<div>

List Security & Configuration Events

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `payload` | <code>oas:NotificationListBody</code> | Yes |  |
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:ListSecurityConfigEventsEnvelope|error`

**Sample code:**

```ballerina
oas:ListSecurityConfigEventsEnvelope result = check pricefxClient->listSecurityConfigurationEvents(payload);
```

</div>
</details>

#### Heartbeat

<details>
<summary>listTasks</summary>

<div>

List Tasks

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:generalResponse|error`

**Sample code:**

```ballerina
oas:generalResponse result = check pricefxClient->listTasks();
```

</div>
</details>

#### MCP

<details>
<summary>getMcpRoles</summary>

<div>

Get MCP Roles

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:McpRolesEnvelope|error`

**Sample code:**

```ballerina
oas:McpRolesEnvelope result = check pricefxClient->getMcpRoles();
```

</div>
</details>

<details>
<summary>getMcpTools</summary>

<div>

Get MCP Tools

**Parameters:**

| Name | Type | Required | Description |
|------|------|----------|--------------|
| `headers` | <code>map&lt;string&#124;string[]&gt;</code> | No | Headers to be sent with the request |

**Returns:** `oas:McpToolsEnvelope|error`

**Sample code:**

```ballerina
oas:McpToolsEnvelope result = check pricefxClient->getMcpTools();
```

</div>
</details>
