#!/bin/bash
input="-"
CONTAINER_CONFIG=$(cat "$input")
PSTREE=$(pstree -AacTlSucp -s "$$")
LAST_PODMAN_PPID=$(echo "${PSTREE}" | grep -C 1 podman | head -n 1 | awk -F, '{print $2}' | awk '{print $1}')
if [ -z "$LAST_PODMAN_PPID" ]
then
   LAST_USER="?"
else
   LAST_USER=$(ps -o user= -p "${LAST_PODMAN_PPID}")
fi
echo "$CONTAINER_CONFIG" | jq ".process.apparmorProfile = \"kubearmor_test-image\""

