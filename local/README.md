# Motion S3 Connector: Local Storage

## Overview
This directory contains the setup for a local instance of the Motion and Motion S3 connector. It demonstrates the use of local disk storage for data, primarily stored in `$HOME/.motion`. This path can be customized using the `MOTION_HOME` environment variable.

This setup is intended for demonstration purposes only and does not connect with the Filecoin network. It highlights the utilization of the DeStor REST API as a backend for the AWS S3 API.

## Prerequisites
- Docker and Docker Compose installed
- AWS CLI installed

## Configuration
- **Default Storage Directory:** `$HOME/.motion` (modifiable via `MOTION_HOME`)
- **Credentials Configuration:** Edit [`authdata.json`](../authdata.json) or set `S3AUTH_CONFIG` (details in [CloudServer documentation](https://github.com/filecoin-project/motion-cloudserver/blob/378f6264f945eddd701f197280f3d94b2a3db1a9/docs/GETTING_STARTED.rst#setting-your-own-access-and-secret-key-pairs))
- **AWS CLI Endpoint URL:** `http://localhost:8000`

## Quick Start
1. **Prepare Storage Directory:** Ensure `MOTION_HOME` exists (default: `$HOME/.motion`).
2. **Launch Services:** Execute `docker compose up`.
3. **Set AWS CLI Credentials:**
   ```
   export AWS_ACCESS_KEY_ID='accessKey1'
   export AWS_SECRET_ACCESS_KEY='verySecretKey1'
   export AWS_DEFAULT_REGION='location-motion-v1'
   export AWS_ENDPOINT_URL='http://localhost:8000'
   ```
4. **Interact Using AWS CLI:** With `AWS_ENDPOINT_URL` set Use AWS CLI commands as normal.

To halt the services, press `Ctrl + C`.

*Note: Use `MOTION_VERSION` and `MOTION_CLOUDSERVER_VERSION` environment variables to specify container versions.*

## Example Usage
Here's a basic example to demonstrate interaction with the Motion S3 Connector:
```shell
# Ensure MOTION_HOME directory
mkdir -p $HOME/.motion

# Start services in the background
docker compose up -d

# Configure AWS CLI credentials
export AWS_ACCESS_KEY_ID='accessKey1' AWS_SECRET_ACCESS_KEY='verySecretKey1' AWS_DEFAULT_REGION='location-motion-v1' AWS_ENDPOINT_URL='http://localhost:8000'

# Create a test file
echo 'Hello Motion S3 connector!' > upload.txt

# Create a new S3 bucket
aws  s3 mb s3://test-bucket

# Upload a file to the bucket
aws  s3 cp upload.txt s3://test-bucket

# List files in the bucket
aws  s3 ls s3://test-bucket

# Download the file
aws  s3 cp s3://test-bucket/upload.txt download.txt

# Remove the file from the bucket
aws  s3 rm s3://test-bucket/upload.txt

# Delete the bucket
aws  s3 rb s3://test-bucket

# Stop the services
docker compose down
```
