#!/bin/bash

# Using the variables USR_ID and GRP_ID to run zookeeper in order
# to provide a way to users to keep ZK_HOME and ZK_DATA with
# useful permissions
uid_gid="${USR_ID:=0}:${GRP_ID:=0}"

# Asserting USR_ID is a number
if ! grep -qsP '[0-9]+' <<< "${USR_ID}"
then
  echo "User ID must be numeric (found ${USR_ID})"
  exit 2
fi

# Asserting GRP_ID is a number
if ! grep -qsP '[0-9]+' <<< "${GRP_ID}"
then
  echo "Group ID must be numeric (found ${GRP_ID})"
  exit 4
fi

chown -R "$uid_gid" "${KAFKA_HOME}/"

test -n "${KAFKA_LOG_DIR}"  && chown "$uid_gid" -R "${KAFKA_LOG_DIR}/"
test -n "${KAFKA_LOG_DIRS}" && chown "$uid_gid" -R "${KAFKA_LOG_DIRS}/"

# Running with sudo provides the mechanism to
# keep sane file permissions
exec sudo -E -u "#${USR_ID}" -g "#${GRP_ID}" "${@}"

