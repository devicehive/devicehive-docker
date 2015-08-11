#!/bin/bash -e
marathon_url="http://${MARATHON_MASTER_ADDRESS}:${MARATHON_MASTER_PORT}"
kafka_appid="devicehive/messagebus/kafka"
postgres_appid="devicehive/data/postgres"

getmtask_address() {
  curl "${marathon_url}/v2/apps/${1}/" | jq '.app.tasks[0] | "\(.host)"' | tr -d '"'
}

getmtask_port() {
  curl "${marathon_url}/v2/apps/${1}/" | jq '.app.tasks[0] | "\(.ports[0])"' | tr -d '"'
}

export DH_POSTGRES_ADDRESS=$(getmtask_address $postgres_appid);
export DH_POSTGRES_PORT=$(getmtask_port $postgres_appid);
export DH_POSTGRES_USERNAME="devicehive";
export DH_POSTGRES_PASSWORD="devicehive";
export DH_POSTGRES_DB="devicehive";
export DH_KAFKA_ADDRESS=$(getmtask_address $kafka_appid);
export DH_KAFKA_PORT=$(getmtask_port $kafka_appid);
export DH_ZK_ADDRESS="${ZK_ADDRESS}"
export DH_ZK_PORT="${ZK_PORT}"
env
./devicehive-start.sh

