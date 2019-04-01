#!/bin/bash

# Required variables:
# wait_condition_notify

# Redirect all outputs
exec > >(tee -i /tmp/cloud-init-bootstrap.log) 2>&1
set -xe

echo "Environment variables:"
env

function wait_condition_send() {
  local status=${1:-SUCCESS}
  local reason=${2:-empty}
  local data_binary="{\"status\": \"$status\", \"reason\": \"$reason\"}"
  echo "Sending signal to wait condition: $data_binary"
  $wait_condition_notify -k --data-binary "$data_binary"
  if [ "$status" == "FAILURE" ]; then
    exit 1
  fi
}

echo "Preparing metadata model"
mount /dev/vdc /mnt/
mkdir -p /srv/salt/reclass/classes/cluster/
touch /srv/salt/reclass/classes/cluster/overrides.yml
cp /mnt/user-data /tmp/user-data
sed -i 's/^mount/# mount/' /tmp/user-data
sed -i 's/^umount/# umount/' /tmp/user-data
sed -i 's/  umount /#  umount /' /tmp/user-data
sed -i 's/^reboot/# reboot/' /tmp/user-data

echo "Running product user-data"

/bin/bash -xe /tmp/user-data
umount /dev/vdc

#Test network
ping  -qc 5 $(ip ro  | grep default | awk '{print $3}') || wait_condition_send "FAILURE" "Gateway is unpiggable"
ping  -qc 5 8.8.8.8 || wait_condition_send "FAILURE" "8.8.8.8 is unpiggable"
ping  -qc 5 ya.ru || wait_condition_send "FAILURE" "ya.ru is unpiggable"

wait_condition_send "SUCCESS" "Instance successfuly started."

reboot
