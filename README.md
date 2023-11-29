# Motion S3 Connector

The Motion S3 Connector showcases a bridge between the Amazon S3 client libraries and [Motion](https://github.com/filecoin-project/motion). By leveraging this connector, users can seamlessly store and fetch data through Motion, an API layer crafted to facilitate Filecoin storage layer integration. This connector utilizes a [Zenko CloudServer](https://www.zenko.io/cloudserver/) - an Amazon S3-compatible storage server - and integrates a tailored Motion client. This client is responsible for converting S3 requests to Motion requests and vice versa.

## Demos

This repository contains two demo setups:
1. [**local**](./local): local storage without Filecoin interaction.
2. [**local-devnet**](./local-devnet): full end-to-end S3 <-> Filecoin SP interaction using a local Boost Devnet.

To run the demos, see README within each corresponding directory.

## Setting Up Zenko CloudServer with Motion Storage Backend

### Prerequisites

- [Docker](https://docs.docker.com/install/) for deploying via `docker-compose`.
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) to communicate with the CloudServer.
- AWS test credentials provided in `.env` are required for CloudServer authentication. For alternative methods, refer to [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html).
- one or more FileCoin Storage provider address specified as comma separated list under `MOTION_STORAGE_PROVIDERS` environment variable.
- Filecoin wallet key with sufficient FileCoin funds specified as hex encoded string under `MOTION_WALLET_KEY` environment variable.

### Launching Motion and CloudServer

Initiate both the Motion API server and the CloudServer with:

```bash
docker compose up
```

This starts the Motion HTTP API at `http://localhost:40080` and the CloudServer at `https://localhost:8000`.

### Configuring AWS CLI with Test Credentials

To set up the AWS CLI with the designated test credentials, execute:

```bash
export AWS_ACCESS_KEY_ID=accessKey1
export AWS_SECRET_ACCESS_KEY=verySecretKey1
export AWS_DEFAULT_REGION=location-motion-v1
```

These credentials correspond to a test user on our local CloudServer. The predefined region `location-motion-v1` directs CloudServer to employ the Motion storage backend.

See [Overriding Default AWS Credentials](#overriding-default-aws-credentials) for instructions on how to override the default credentials accepted by the server side.

### Bucket Operations

1. **Creating a Bucket**  
   After starting the servers, generate a bucket using:

   ```bash
   aws --endpoint-url http://localhost:8000 s3 mb s3://mybucket
   ```

2. **Uploading Objects**  
   Transfer a file to the new bucket:

   ```bash
   aws --endpoint-url http://localhost:8000 s3 cp README.md s3://mybucket
   ```

   Alternatively, utilize:

   ```bash
   aws --endpoint-url http://localhost:8000 s3api put-object --bucket mybucket --key README.md --body README.md
   ```

3. **Listing Objects**  
   To view the contents of your bucket:

   ```bash
   aws --endpoint-url http://localhost:8000 s3 ls s3://mybucket
   ```

4. **Downloading Objects**  
   Retrieve an uploaded object with:

   ```bash
   aws --endpoint-url http://localhost:8000 s3 cp s3://mybucket/README.md README.md
   ```

   Or, use:

   ```bash
   aws --endpoint-url http://localhost:8000 s3api get-object --bucket mybucket --key README.md README.md
   ```
## Overriding Default AWS Credentials

In scenarios where you wish to use different credentials than the default ones, the Motion S3 Connector allows users to override the default AWS credentials. This can be particularly useful for more advanced use-cases, testing, or specific security measures.

### ***How to Override Credentials***

To update the AWS credentials, edit the [`authdata.json`](authdata.json) file with your preferred access credentials. After making the changes, restart Docker Compose to apply the updated credentials on the server.
