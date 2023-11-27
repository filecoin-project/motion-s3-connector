#!/usr/bin/env bash

ENV_FILE=${PWD}/motion-stack/.env.local

echo "Setting Boost pricing..."
for _ in {1..10}
do
  curl -X POST -d '{"operationName":"AppStorageAskUpdateMutation","variables":{"update":{"Price":"0", "VerifiedPrice": 0}},"query":"mutation AppStorageAskUpdateMutation($update: StorageAskUpdate!) {\n  storageAskUpdate(update: $update)\n}\n"}' http://localhost:8080/graphql/query && break
  echo "Retrying..."
  sleep 5
done
echo -e "\nBoost pricing set"

echo "Configuring Motion stack environment variables"
export "$(docker compose -f ./devnet/docker-compose.yaml exec lotus lotus auth api-info --perm=admin)"
IFS=: read -r LOTUS_TOKEN <<< "${FULLNODE_API_INFO}"
MOTION_WALLET_ADDR="$(docker compose -f ./devnet/docker-compose.yaml exec lotus lotus wallet new)"
MOTION_WALLET_KEY="$(docker compose -f ./devnet/docker-compose.yaml exec lotus lotus wallet export ${MOTION_WALLET_ADDR})"
DEFAULT_WALLET="$(docker compose -f ./devnet/docker-compose.yaml exec lotus lotus wallet default)"

docker compose -f ./devnet/docker-compose.yaml exec lotus lotus send --from "${DEFAULT_WALLET}" "${MOTION_WALLET_ADDR}" 10

cp ./motion-stack/.env "${ENV_FILE}"
echo "LOTUS_TOKEN=${LOTUS_TOKEN}" >> "${ENV_FILE}"
echo "MOTION_WALLET_ADDR=${MOTION_WALLET_ADDR}" >> "${ENV_FILE}"
echo "MOTION_WALLET_KEY=${MOTION_WALLET_KEY}" >> "${ENV_FILE}"
echo "MOTION_HOME=${PWD}/motion-stack/data" >> "${ENV_FILE}"

echo "Starting Motion software stack..."
mkdir -p ./motion-stack/data
docker compose --env-file ${ENV_FILE} -f ./motion-stack/docker-compose.yaml up -d

echo "Waiting for motion service to be in running state..."
while ! docker compose --env-file ${ENV_FILE} -f ./motion-stack/docker-compose.yaml ps motion | grep -q 'Up'; do \
  echo "Waiting for motion service..."; \
  sleep 1; \
done
echo "Motion service is running."
