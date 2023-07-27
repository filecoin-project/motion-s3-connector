# motion-s3-connector

The Motion S3 Connector is an example of how clients can use existing Amazon S3 client libraries to store and retrieve data with [Motion](https://github.com/filecoin-project/motion), an API layer designed to make it easy for software vendors to integrate Filecoin as a storage layer. The connector is a [Zenko CloudServer](https://www.zenko.io/cloudserver/), an Amazon S3 compatible object storage server, with a custom Motion client that translates S3 requests into Motion requests and vice versa.

## Zenko CloudServer with Motion Storage Backend

### Prerequisites

* Docker container runtime for running docker-compose. We'll be using [Docker](https://docs.docker.com/install/).
* [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html) for interacting with CloudServer.
* AWS test credentials in the provided `.env` need to be used for authenticating with CloudServer. See [AWS CLI Configuration](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html) for more information on other ways to use these credentials.

### Start Motion and CloudServer

Both the Motion API server and CloudServer can be started by running:

```bash
docker compose up
```

The above command starts the Motion HTTP API exposed on the default listening address http://localhost:40080 and a CloudServer on https://localhost:8000.

### Export AWS Credentials

The AWS CLI needs to be configured with the following AWS test credentials. The credentials can be exported by running:

```bash
export AWS_ACCESS_KEY_ID=accessKey1
export AWS_SECRET_ACCESS_KEY=verySecretKey1
export AWS_DEFAULT_REGION=location-motion-v1
```

Our local CloudServer has been set up with a test user with these credentials. The default region `location-motion-v1` tells CloudServer to use the Motion storage backend.

### Create a bucket

With the Motion API server and CloudServer running, we can create a bucket using the AWS CLI `s3 mb` command:

```bash
aws --endpoint-url http://localhost:8000 s3 mb s3://mybucket
```

The `--endpoint-url` flag tells the AWS CLI to use our local CloudServer endpoint instead of the default Amazon S3 endpoint.

### Upload an object

We can upload an object to the bucket we just created using the AWS CLI `s3 cp` command:

```bash
aws --endpoint-url http://localhost:8000 s3 cp README.md s3://mybucket
```

We can also use the `s3api put-object` command to upload an object:

```bash
aws --endpoint-url http://localhost:8000 s3api put-object --bucket mybucket --key README.md --body README.md
```

### List objects

We can list the objects in the bucket we just created using the AWS CLI `s3 ls` command:

```bash
aws --endpoint-url http://localhost:8000 s3 ls s3://mybucket
```

### Download an object

We can download the object we just uploaded using the AWS CLI `s3 cp` command:

```bash
aws --endpoint-url http://localhost:8000 s3 cp s3://mybucket/README.md README.md
```

We can also use the `s3api get-object` command to download an object:

```bash
aws --endpoint-url http://localhost:8000 s3api get-object --bucket mybucket --key README.md README.md
```