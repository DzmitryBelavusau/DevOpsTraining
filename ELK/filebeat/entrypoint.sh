#!/bin/bash 

service apache2 start
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start apache2: $status"
  exit $status
fi

filebeat -c /etc/filebeat/filebeat.yml -e
status=$?
if [ $status -ne 0 ]; then
  echo "Failed to start filebeat: $status"
  exit $status
fi