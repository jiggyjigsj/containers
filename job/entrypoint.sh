#!/bin/bash
function log {
  echo "[INFO][`date "+%Y/%m/%d %H:%M:%S"`] $1"
}

function clean {
  ## Check if these exists
  if [[ -z $USER ]]; then log "Missing env USER"; exit 1; fi
  if [[ -z $PASS ]]; then log "Missing env PASS"; exit 1; fi
  if [[ -z $FSPATH ]]; then log "Missing env FSPATH"; exit 1; fi

  space=$(df -h $FSPATH | egrep -o '[0-9]+%')
  ns=$(echo $space | sed 's/%//')
  thres=75

  log "Free space: ${space} and threshold at: ${thres}"

  paused=$(curl -m 5 -s http://${USER}:${PASS}@nzbget:6789/jsonrpc/status | jq .result.DownloadPaused)

  if [[ ${paused} == "true" ]]; then
    if [[ $ns -lt  $thres ]]; then
      log "Resuming Downloads"
      curl -m 5 -s -XPOST http://${USER}:${PASS}@nzbget:6789/jsonrpc -d '{"method": "resumedownload"}' | jq .result
    fi
  else
    log "SKIPPING - Download not paused"
  fi
}

while :
do
  clean
  sleep 30
done
