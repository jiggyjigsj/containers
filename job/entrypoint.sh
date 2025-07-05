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

  log "Free space: ${space} with threshold at: ${thres}%"

  paused=$(curl -m 5 -s http://${USER}:${PASS}@nzbget:6789/jsonrpc/status | jq .result.DownloadPaused)

  if [[ ${paused} == "true" ]]; then
    if [[ $ns -le  $thres ]]; then
      log "Resuming Downloads"
      curl -m 5 -s -XPOST http://${USER}:${PASS}@nzbget:6789/jsonrpc -d '{"method": "resumedownload"}' | jq .result
    fi
  else
    log "SKIPPING - Download not paused"
  fi
}

# function fdclean {
#   FDPATH=/mnt/storage
#   IGNORE_HIMYM="tv/How I Met Your Mother"
#   # find $FDPATH -type f ! -path "$FSPATH/tv/How I Met Your Mother/*" -printf '%T+ %p\n' | sort | head -n 10

#   if [[ -z $FDPATH ]]; then log "Missing env FDPATH"; exit 1; fi

#   space=$(df -h $FDPATH | egrep -o '[0-9]+%')
#   ns=$(echo $space | sed 's/%//')
#   thres=85

#   log "Free space: ${space} with threshold at: ${thres}%"

#   if [[ $ns -gt  $thres ]]; then
#     local ignore_list
#     log "$FDPATH is lower then $thres"
#     for var in "${!IGNORE_@}"; do
#       log "INFO - ${var}=${!var}"
#       ignore_list="$ignore_list ! -path '$FDPATH/${!var}/*'"
#     done
#     log "INFO - IGNORE PATHS $ignore_list"

#     list_of_files=$(find $FDPATH -type f$ignore_list -printf '%T+ %p\n' | sort | head -n 10)
#     echo list_of_files
#   fi
# }

# TIME="${60:-default}"

while :
do
  clean
  sleep $TIME
done

#### Below is test case
#  3001  export   FDPATH=/mnt/storage\n
#  3013  export IGNORE_HIMYM="tv/How I Met Your Mother"
#  3020  export IGNORE_HIMYM="tv/How I Met Your Mother"
#  3026  export IGNORE_HIMYT="tv/How I Met Your Mother"
#  3064  export IGNORE_HIMYT="tv/1883"

# #!/bin/bash
# mset -x
# function log {
#   echo "[INFO][`date "+%Y/%m/%d %H:%M:%S"`] $1"
# }

# function fsclean {
#   FDPATH=/mnt/storage
#   IGNORE_HIMYM="tv/How I Met Your Mother"
#   # find $FDPATH -type f ! -path "$FSPATH/tv/How I Met Your Mother/*" -printf '%T+ %p\n' | sort | head -n 10

#   if [[ -z $FDPATH ]]; then log "Missing env FDPATH"; exit 1; fi

#   space=$(df -h $FDPATH | egrep -o '[0-9]+%')
#   ns=$(echo $space | sed 's/%//')
#   thres=85

#   log "Free space: ${space} and threshold at: ${thres}%"

#   if [[ $ns -lt  $thres ]]; then
#     local ignore_list
#     log "$FDPATH is lower then $thres"
#     for var in "${!IGNORE_@}"; do
#       log "INFO - IGNOREING ${var}=${!var}"
#       ignore_list="$ignore_list ! -path $FDPATH/${!var}/*"
#     done

#     log "INFO - IGNORE PATHS $ignore_list"
#     list_of_files=$(find $FDPATH -type f "$ignore_list" -printf '%T+ %p\n' | sort | head -n 10)
#     echo $list_of_files
#   fi
# }

# fsclean

# build me now
