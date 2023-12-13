#!/usr/bin/env bash

ON_PROXY_PID=$(ps aux | grep on-proxy | grep -v grep | awk {'print $2'} 2> /dev/null)
#echo $ON_PROXY_PID
if [ -n "${ON_PROXY_PID}" ]; then
  echo "proxy is already running with pid $ON_PROXY_PID"
else
  on-proxy >> /dev/null &
fi
