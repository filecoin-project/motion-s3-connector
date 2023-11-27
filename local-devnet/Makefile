LOTUS_VERSION ?= v1.23.2
LOTUS_API_WAIT_TIMEOUT ?= 20m

.PHONY: devnet/download-proof-params
devnet/download-proof-params: SECTOR_SIZE ?= 8388608
devnet/download-proof-params:
	@echo "Downloading Filecoin Proof Parameters for sector size $(SECTOR_SIZE)..."
	docker run -v $(PWD)/devnet/cache/filecoin-proof-parameters:/var/tmp/filecoin-proof-parameters ghcr.io/filecoin-shipyard/lotus-containers:lotus-$(LOTUS_VERSION)-devnet lotus fetch-params 8388608
	@echo "Done."

.PHONY: devnet/up
devnet/up: devnet/download-proof-params
	mkdir -p ./devnet/cache ./devnet/data
	@echo 'Starting Boost with local devnet...'
	docker compose -f ./devnet/docker-compose.yaml up -d
	@echo 'Awaiting Lotus full node startup...'
	docker compose -f ./devnet/docker-compose.yaml exec lotus lotus wait-api --timeout=$(LOTUS_API_WAIT_TIMEOUT)
	@echo 'Lotus full node started.'
	@echo 'Awaiting Lotus-miner full node startup...'
	docker compose -f ./devnet/docker-compose.yaml exec lotus-miner lotus-miner wait-api --timeout=$(LOTUS_API_WAIT_TIMEOUT)
	@echo 'Lotus-miner full node started.'

.PHONY: motion/up
motion/up:
	./motion-stack/start.sh

.PHONY: start
start: devnet/up motion/up

.PHONY: stop
stop:
	docker compose -f ./motion-stack/docker-compose.yaml down
	docker compose -f ./devnet/docker-compose.yaml down
	rm -rf ./devnet/data ./motion-stack/data ./motion-stack/.env.local
