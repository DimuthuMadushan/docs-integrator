---
title: Setup Guide
---
# Setup Guide

This guide walks you through creating an AWS IAM user and obtaining the access credentials required to use the AWS S3 connector.

## Prerequisites

- An active AWS account. If you do not have one, [sign up here](https://portal.aws.amazon.com/billing/signup).

## Step 1: Sign in to the AWS Management Console

1. Go to [console.aws.amazon.com](https://console.aws.amazon.com/) and sign in.
2. In the top navigation bar, select the AWS **Region** where you want to create your S3 buckets (for example, `us-east-1`).

## Step 2: Create an IAM user

1. Open the **IAM** console by searching for "IAM" in the AWS Management Console.

   ![Search for IAM](/img/connectors/catalog/storage-file/aws.s3/setup/create-user-1.jpeg)

2. In the left navigation pane, select **Users**.

   ![IAM Dashboard - select Users](/img/connectors/catalog/storage-file/aws.s3/setup/create-user-2.jpeg)

3. Select **Create user**.

   ![Users page - Create user](/img/connectors/catalog/storage-file/aws.s3/setup/create-user-3.jpeg)

4. Enter a **User name** (for example, `S3-USER`) and select **Next**.

   ![Specify user details](/img/connectors/catalog/storage-file/aws.s3/setup/specify-user-details.jpeg)

5. Under **Set permissions**, select **Attach policies directly**. Search for and select the **AmazonS3FullAccess** managed policy (or a custom policy with the minimum S3 permissions your integration requires).

   ![Set user permissions](/img/connectors/catalog/storage-file/aws.s3/setup/set-user-permissions.jpeg)

6. Select **Next**, review the details, and select **Create user**.

   ![Review and create user](/img/connectors/catalog/storage-file/aws.s3/setup/review-create-user.jpeg)

7. You should see a confirmation that the user was created successfully.

   ![User created successfully](/img/connectors/catalog/storage-file/aws.s3/setup/users.jpeg)

:::tip
For production use, follow the principle of least privilege — create a custom IAM policy that grants only the specific S3 actions and resources your integration needs.
:::

## Step 3: Generate access keys

1. In the IAM console, select the user you just created. Under **Access keys**, select **Create access key**.

   ![Create access key](/img/connectors/catalog/storage-file/aws.s3/setup/create-access-key-1.png)

2. Select the **Application running outside AWS** use case, then select **Next**.

   ![Select use case](/img/connectors/catalog/storage-file/aws.s3/setup/select-usecase.png)

3. Optionally add a description tag, then select **Create access key**.

4. Copy the **Access key ID** and **Secret access key** — these are your `accessKeyId` and `secretAccessKey`.

   ![Retrieve access keys](/img/connectors/catalog/storage-file/aws.s3/setup/retrieve-access-key.png)

:::warning
The secret access key is shown only once. Store both keys securely and do not commit them to source control. Use Ballerina's `configurable` feature and a `Config.toml` file to supply them at runtime.
:::

## Step 4: Note your AWS region

Identify the AWS Region for your S3 operations (for example, `us-east-1`, `eu-west-1`, `ap-southeast-1`). This value is passed as the `region` configuration parameter when initializing the connector.

:::note
If you do not specify a region, the connector defaults to **US East (N. Virginia)** (`us-east-1`).
:::

## What's next

- [Action reference](action-reference.md): Available operations
