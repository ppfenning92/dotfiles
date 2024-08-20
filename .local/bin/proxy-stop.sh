#!/usr/bin/env

ON_PROXY_PID=$(ps aux | grep on-proxy | grep -v grep | awk {'print $2'} 2>/dev/null)
#echo $ON_PROXY_PID
if [ -n "${ON_PROXY_PID}" ]; then
  kill -9 $ON_PROXY_PID
  echo "Terminated Proxy"
else
  echo "Proxy is not running"
fi
