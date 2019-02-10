#!/bin/sh

set -e

log() {
  echo "$(date -Iseconds): $1"
}

get_ip() {
  dig +short myip.opendns.com @resolver1.opendns.com
}

get_zone_id() {
  curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$3" -H "X-Auth-Key: $1" -H "X-Auth-Email: $2" -H "Content-Type: application/json" | jq -r '.result[0].id'
}

get_record_id() {
  curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$3/dns_records?name=$4" -H "X-Auth-Key: $1" -H "X-Auth-Email: $2" -H "Content-Type: application/json" | jq -r '.result[0].id'
}

update_ip() {
  curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$3/dns_records/$4" -H "X-Auth-Key: $1" -H "X-Auth-Email: $2" -H "Content-Type: application/json" --data "{\"type\":\"A\",\"name\":\"$5\",\"content\":\"$6\",\"ttl\":120}"
}

log "Phone home"

ZONE_ID="$({ test -e zone_id.txt || get_zone_id ${AUTH_KEY} ${AUTH_EMAIL} ${ZONE_NAME} > zone_id.txt; } && cat zone_id.txt)"
RECORD_ID="$({ test -e record_id.txt || get_record_id ${AUTH_KEY} ${AUTH_EMAIL} ${ZONE_ID} ${RECORD_NAME} > record_id.txt; } && cat record_id.txt)"

log "Zone ID for ${ZONE_NAME}: ${ZONE_ID}"
log "Record ID for ${RECORD_NAME}: ${RECORD_ID}"

while true; do

  CACHED_IP_ADDRESS="$({ test -e ip.txt || get_ip > ip.txt; } && cat ip.txt)"
  log "Cached IP address: ${CACHED_IP_ADDRESS}"

  LIVE_IP_ADDRESS=$(get_ip)

  if [[ "${CACHED_IP_ADDRESS}" != "${LIVE_IP_ADDRESS}" ]]; then

    log "Updating IP address..."

    RESPONSE=$(update_ip ${AUTH_KEY} ${AUTH_EMAIL} ${ZONE_ID} ${RECORD_ID} ${RECORD_NAME} ${LIVE_IP_ADDRESS})

    log "...done"

    echo "${LIVE_IP_ADDRESS}" > ip.txt
    log "Cached IP address updated to: ${LIVE_IP_ADDRESS}"

    log "Status code: $?"
    log "${RESPONSE}"
  else
    log "IP address hasn't changed from: ${CACHED_IP_ADDRESS}"
  fi

  sleep 360

done
