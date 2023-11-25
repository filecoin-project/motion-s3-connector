# Motion S3 Connector: Mongodb for metadata

## Overview

When using mongodb to store metadata, mongodb is expected to operate as a replica set. For a real deployment this is something that should be set up in the target infrastructure. This docker-compose configuration only sets up mongodb as an example to demonstrate that it can be used.

## Prerequisites
- Docker and Docker Compose installed
- AWS CLI installed
- Mongodb keyfile and replica set inilized.

### Create keyfile for mongo replica set

Create keyfile in `$HOME/.motion/zenko/mongodbMetadata/`

```shell
sudo su
echo secretkey > $HOME/.motion/zenko/mongodbMetadata/keyfile
chown 999:docker $HOME/.motion/zenko/mongodbMetadata/keyfile
chmod 600 $HOME/.motion/zenko/mongodbMetadata/keyfile
```

If is necessary to do this as root since mongodb creates this directory with root ownership.

### Initialize mongo replica set

To initiate the replica set, run this after mongodb is started:
```
mongosh -u root -p changeme
rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "mongodb:27017" } ] })
```

## Example Usage
Here's a basic example to demonstrate interaction with the Motion S3 Connector:
```shell
# Ensure MOTION_HOME directory
mkdir -p $HOME/.motion

# Start services in the background
docker compose up -d

# Configure AWS CLI credentials
export AWS_ACCESS_KEY_ID='accessKey1' AWS_SECRET_ACCESS_KEY='verySecretKey1' AWS_DEFAULT_REGION='location-motion-v1' AWS_ENDPOINT_URL='http://localhost:8000'

# Configure key file if first time running
sudo su
echo secretkey > $HOME/.motion/zenko/mongodbMetadata/keyfile
chown 999:docker $HOME/.motion/zenko/mongodbMetadata/keyfile
chmod 600 $HOME/.motion/zenko/mongodbMetadata/keyfile
exit

# Initialize mongo replica set
mongosh -u root -p changeme
rs.initiate({ _id: "rs0", members: [ { _id: 0, host: "mongodb:27017" } ] })
exit

# Create a test file
echo 'Hello Motion S3 connector!' > upload.txt

# Create a new S3 bucket
aws s3 mb s3://test-bucket

# Upload a file to the bucket
aws s3 cp upload.txt s3://test-bucket

# List files in the bucket
aws s3 ls s3://test-bucket

# Download the file
aws s3 cp s3://test-bucket/upload.txt download.txt

# Remove the file from the bucket
aws s3 rm s3://test-bucket/upload.txt

# Delete the bucket
aws  s3 rb s3://test-bucket

# Stop the services
docker compose down
```
