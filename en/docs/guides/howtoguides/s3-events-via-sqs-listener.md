---
sidebar_position: 3
title: "File Integrations on S3 File Events"
sidebar_label: "File Integrations on S3 File Events"
description: Configure AWS S3 to push object-created notifications to an SQS queue, then consume and parse those events in a Ballerina integration using the aws.sqs listener.
keywords: [wso2 integrator, aws, s3, sqs, event-driven, csv, file processing, ballerina, listener, trigger, object notification, cloud]
---

import Tabs from '@theme/Tabs';
import TabItem from '@theme/TabItem';
import ThemedImage from '@theme/ThemedImage';
import useBaseUrl from '@docusaurus/useBaseUrl';

# File Integrations on S3 File Events

This integration triggers an action each time a file is uploaded to an Amazon S3 bucket. AWS does not have a built-in trigger for S3, and one of the recommended approaches is to publish these events to an AWS SQS queue. S3 publishes an object-created notification to the queue, and the AWS SQS trigger consumes it — so your service reacts within seconds of the upload without polling S3.

**What you'll build:** A Ballerina integration that reacts every time a file is uploaded to an S3 bucket. S3 pushes a notification to an SQS queue; the `aws.sqs` listener picks it up and your service logs the bucket name, object key, and file size without polling S3 directly.

## How it works

```text
S3 Bucket  ──(ObjectCreated)──►  SQS Queue  ──(poll)──►  sqs:Listener  ──►  onMessage callback
```

1. A file is uploaded to the S3 bucket.
2. S3 sends a JSON event notification to the SQS queue.
3. The `sqs:Listener` polls the queue, receives the message, and invokes `onMessage`.
4. Your service parses the S3 event, logs the CSV file details, and deletes the message from the queue.

## Before you begin

:::info Prerequisites

- An AWS account with permissions to manage S3, SQS, and IAM.
- A working WSO2 Integrator environment:
  - [Cloud setup](../../get-started/setup/cloud-setup.md) — browser-based editor in the cloud.
  - [Local setup](../../get-started/setup/local-setup.md) — WSO2 Integrator IDE on your machine.
- AWS Access Key ID and Secret Access Key for an IAM user who has the necessary `sqs:ReceiveMessage`, `sqs:DeleteMessage`, and `sqs:GetQueueAttributes` permissions on your SQS queue. See the [AWS SQS Setup Guide](../../connectors/catalog/messaging/aws.sqs/setup-guide.md) if you need to create credentials.

:::

## Part 1: Configure AWS

### Step 1: Create the SQS queue

1. Open the [SQS Console](https://console.aws.amazon.com/sqs/) and select **Create queue**.
2. Choose **Standard** queue type.
3. Give the queue a name, for example `s3-events`, and complete the creation.

### Step 2: Grant S3 permission to write to the queue

S3 needs explicit permission to publish messages to your queue. Open the queue, go to **Access policy**, and add the following statement inside the `Statement` array of the existing policy. Replace the placeholders with your own values.

```json
{
  "Sid": "allow-s3-send-message",
  "Effect": "Allow",
  "Principal": {
    "Service": "s3.amazonaws.com"
  },
  "Action": "SQS:SendMessage",
  "Resource": "arn:aws:sqs:<region>:<account-id>:s3-events",
  "Condition": {
    "ArnLike": {
      "aws:SourceArn": "arn:aws:s3:::<your-bucket-name>"
    },
    "StringEquals": {
      "aws:SourceAccount": "<account-id>"
    }
  }
}
```

Save the updated policy.

### Step 3: Create the S3 bucket

1. Open the [S3 Console](https://console.aws.amazon.com/s3/) and select **Create bucket**.
2. Enter a globally unique bucket name and finish the creation with the default settings.

### Step 4: Configure S3 event notifications

Link the bucket to the queue so S3 knows where to send events.

1. Open your bucket and go to the **Properties** tab.
2. Scroll to **Event notifications** and select **Create event notification**.
3. Fill in the form:

   | Field | Value |
   |---|---|
   | Event name | `object-created` |
   | Event types | `s3:ObjectCreated:*` |
   | Destination | SQS queue → select `s3-events` |

4. Select **Save changes**.

:::tip Verify the setup
Upload any `.csv` file to the bucket. Open the SQS console, select **Send and receive messages**, and click **Poll for messages**. You should see a JSON message appear. You may also see a one-off `s3:TestEvent` message immediately after configuration — that is normal and can be safely deleted.
:::

---

## Part 2: Build the Ballerina integration

### Step 5: Create the integration

Create a new integration project in WSO2 Integrator. Name the project `s3-and-sqs-integration`.

<ThemedImage
    alt="Create the s3-and-sqs-integration project"
    sources={{
        light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-and-sqs-integration.png'),
        dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-and-sqs-integration.png'),
    }}
/>

### Step 6: Create the record types

Define the record types that map to the S3 event notification JSON structure. These types let Ballerina parse the incoming SQS message body into typed records.

Add two **Record Type** artifacts to the project:

**`S3EventRecord`** — represents a single event entry inside the notification:

```ballerina
type S3EventRecord record {
    string eventSource;
    string eventName;
    string eventTime;
    string awsRegion;
    record {
        record {string name; string arn;} bucket;
        record {string key; int size; string eTag;} 'object;
    } s3;
};
```

**`S3Notification`** — the top-level wrapper that contains an array of event records:

```ballerina
type S3Notification record {
    S3EventRecord[] Records;
};
```

### Step 7: Add a Trigger artifact

Add a **Trigger** artifact to the integration and search for `aws sqs`. Select the **AWS SQS** trigger to open the listener configuration form.

Fill in the connection parameters:

| Field | Value |
|---|---|
| Region | The AWS region where your SQS queue is located, for example `US_EAST_1` |
| Access Key ID | Your AWS Access Key ID (use a configurable) |
| Secret Access Key | Your AWS Secret Access Key (use a configurable) |
| Queue URL | The full URL of your SQS queue, for example `https://sqs.us-east-1.amazonaws.com/<account-id>/s3-events` |
| Poll Interval | `5` (seconds between polls) |
| Wait Time | `20` (long-poll duration in seconds) |
| Visibility Timeout | `30` (seconds a received message is hidden from other consumers) |

:::tip Best practice
Bind `accessKeyId`, `secretAccessKey`, and `queueUrl` to configurable variables rather than hardcoding them. In the expression editor, select **Configurables → New Configurable** to create a runtime-supplied value.
:::

Set `autoDelete` to `false` so your service controls when the message is removed from the queue.

<ThemedImage
    alt="SQS trigger configurations"
    sources={{
        light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/sqs-trigger-configurations.png'),
        dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/sqs-trigger-configurations.png'),
    }}
/>

### Step 8: Implement the service callbacks

Switch to the **Ballerina Code** tab to see the full source, or continue building in the **Visual Designer**.

<Tabs>
<TabItem value="ui" label="Visual Designer" default>

After adding the SQS Trigger artifact and configuring the listener as described in Step 7, select **+ Add Handler** and choose **On Message** to add the `onMessage` callback.

<ThemedImage
    alt="Add the onMessage handler to the SQS trigger"
    sources={{
        light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/add-sqs-handler.png'),
        dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/add-sqs-handler.png'),
    }}
/>

Open the `onMessage` callback and add the following steps:

1. **Declare Variable** — name it `notification`, set the type to `S3Notification`, and set the expression to `check message.body.cloneWithType(S3Notification)`. Add an **Error Handler** block to handle parse failures.

   <ThemedImage
       alt="Declare the notification variable"
       sources={{
           light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/declare-s3-variable.png'),
           dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/declare-s3-variable.png'),
       }}
   />

2. **Foreach** — set the collection to `notification.Records`, the variable name to `eventRecord`, and the variable type to `S3EventRecord`.

   <ThemedImage
       alt="Add a foreach loop over notification Records"
       sources={{
           light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-declare-foreach-loop.png'),
           dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-declare-foreach-loop.png'),
       }}
   />

3. **Print** — inside the foreach loop, add an `io:println` node with the value `eventRecord`.

   <ThemedImage
       alt="Print each event record"
       sources={{
           light: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-println.png'),
           dark: useBaseUrl('/img/guides/usecases/s3-events-via-sqs-listener/s3-println.png'),
       }}
   />

</TabItem>
<TabItem value="code" label="Ballerina Code">

The integration produces two files. Create or update them as shown below.

**`Ballerina.toml`** — declares the SQS connector dependency:

```toml
[package]
org = "myorg"
name = "s3_csv_event_processor"
version = "0.1.0"
distribution = "2201.13.0"
```

**`Config.toml`** — supply your actual AWS credentials at runtime (never commit this file):

```toml
accessKeyId = "<your-access-key-id>"
secretAccessKey = "<your-secret-access-key>"
queueUrl = "https://sqs.us-east-1.amazonaws.com/<account-id>/s3-events"
```

**`main.bal`** — the listener and service logic:

```ballerina
import ballerina/io;
import ballerinax/aws.auth;
import ballerinax/aws.sqs;

// ---------------------------------------------------------------------------
// AWS credentials and queue URL — supplied via Config.toml at runtime
// ---------------------------------------------------------------------------
configurable string accessKeyId = ?;
configurable string secretAccessKey = ?;
configurable string queueUrl = ?;

// ---------------------------------------------------------------------------
// Types that mirror the S3 event notification structure
// ---------------------------------------------------------------------------

type S3EventRecord record {
    string eventSource;
    string eventName;
    string eventTime;
    string awsRegion;
    record {
        record {string name; string arn;} bucket;
        record {string key; int size; string eTag;} 'object;
    } s3;
};

type S3Notification record {
    S3EventRecord[] Records;
};

// ---------------------------------------------------------------------------
// Listener — polls the SQS queue every 5 seconds using long polling
// ---------------------------------------------------------------------------

listener sqs:Listener sqsListener = new (
    {
        region: sqs:US_EAST_1,
        auth: {
            accessKeyId: accessKeyId,
            secretAccessKey: secretAccessKey
        }
    },
    pollingConfig = {
        pollInterval: 5,   // seconds between polls
        waitTime: 20,      // long-poll wait time (0–20 s)
        visibilityTimeout: 30
    }
);

// ---------------------------------------------------------------------------
// Service — attached to the listener, processes each message
// ---------------------------------------------------------------------------

@sqs:ServiceConfig {queueUrl: "https://sqs.us-east-1.amazonaws.com/<account-id>/s3-events"}
service sqs:Service on sqsListener {
    remote function onMessage(sqs:Message message) returns error? {
        do {
            S3Notification notification = check message.body.cloneWithType(S3Notification);
            foreach S3EventRecord eventRecord in notification.Records {
                io:println(string `bucket=${eventRecord.s3.bucket.name} key=${eventRecord.s3.'object.key} size=${eventRecord.s3.'object.size}`);
            }
        } on fail error err {
            // handle error
            return error("unhandled error", err);
        }
    }

}
```

</TabItem>
</Tabs>

---

## Step 9: Run and verify

1. Open **Configurations** in WSO2 Integrator and supply your AWS credentials and queue URL.
2. Run the integration.
3. Upload a `.csv` file to your S3 bucket.

Within seconds the terminal should print output similar to:

```text
bucket=my-csv-bucket key=reports/sales_q2.csv size=4096
```

:::note Troubleshooting
- **No messages appear** — verify the SQS access policy includes the S3 `SendMessage` permission and the `aws:SourceArn` condition matches your bucket ARN exactly.
- **Parse error** — print the raw `message.body` value and compare it against the [S3 Event Message Structure](https://docs.aws.amazon.com/AmazonS3/latest/userguide/notification-content-structure.html) to check if field names have changed.
- **Test event causes a parse failure** — S3 sends a one-off `s3:TestEvent` message when you first configure event notifications. This message has a different structure and does not contain a `Records` array. You can safely delete it from the SQS console.
:::

---

## What's next

Now that your listener is consuming S3 events, extend the integration further:

- **Read the CSV from S3** — use the `ballerinax/aws.s3` connector's `getObject` action to download the file content inside `onMessage`, then parse it with `ballerina/data.csv`.
- **Filter by prefix** — add a prefix filter (for example `uploads/`) to the S3 event notification configuration in Step 4 so only files under that path trigger events.
- **Fan out to multiple consumers** — subscribe additional SQS queues to an SNS topic and have the S3 bucket notify the topic instead. Each downstream queue can run a separate Ballerina listener.
- **Deploy the integration** — ship to [WSO2 Cloud](../../deploy/cloud/overview.md), a [Docker container](../../deploy/self-hosted/containerized-deployment.md#docker-deployment), or [Kubernetes](../../deploy/self-hosted/containerized-deployment.md#kubernetes-deployment) for production use.
