#!/usr/bin/env bash
set -e

export LOTUS_SKIP_GENESIS_CHECK=${LOTUS_SKIP_GENESIS_CHECK:-_yes_}
export GENESIS_PATH=${GENESIS_PATH:-/var/lib/genesis}
export SECTOR_SIZE=${SECTOR_SIZE:-8388608}
export LOTUS_MINER_PATH=${LOTUS_MINER_PATH:-}

echo Wait for lotus is ready ...
lotus wait-api
echo Lotus ready. Lets go
if [ ! -f "${LOTUS_MINER_PATH}/.init.miner" ]; then
	echo Import the genesis miner key ...
	lotus wallet import --as-default ${GENESIS_PATH}/pre-seal-t01000.key
	echo Set up the genesis miner ...
	lotus-miner init --genesis-miner --actor=t01000 --sector-size=${SECTOR_SIZE} --pre-sealed-sectors=${GENESIS_PATH} --pre-sealed-metadata=${GENESIS_PATH}/pre-seal-t01000.json --nosync
	touch "${LOTUS_MINER_PATH}/.init.miner"
	echo Done
fi

echo Starting lotus miner ...
exec lotus-miner run --nosync
