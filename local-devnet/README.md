# Motion S3 Connector: Boost Local Devnet

## Overview
This directory contains the setup for a local instance of the Motion and Motion S3 connector connected to a local Boost storage provider running on devnet.
It demonstrates an end-to-end interaction starting from S3 connector API all the way to a Filecoin SP.

## Prerequisites
- Docker and Docker Compose installed
- AWS CLI installed

## Quick Start
1. **Start Boost Devnet and Motion software stack:** Run `make start`.
2. **Wait for the services to start:** This command will download necessarry proofs, starts Boost and Lotus nodes and finally configures and starts Motion software stack along with the S3 connector
3. **Set AWS CLI Credentials:**
   ```
   export AWS_ACCESS_KEY_ID='accessKey1'
   export AWS_SECRET_ACCESS_KEY='verySecretKey1'
   export AWS_DEFAULT_REGION='location-motion-v1'
   export AWS_ENDPOINT_URL='http://localhost:8000'
   ```
4. **Interact Using AWS CLI:** With `AWS_ENDPOINT_URL` set Use AWS CLI commands as normal.

To halt the services, run `make stop`.

## Example Usage
Here's a basic example to demonstrate interaction with the Motion S3 Connector:
```shell
# Start Services
make start

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
make stop
```
