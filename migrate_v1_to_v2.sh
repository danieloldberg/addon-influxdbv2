docker exec -it {{ addon_xxxxx_influxdb }} /bin/bash
influx_inspect export -database homeassistant -retention autogen -out /data/exports/influxdb -lponly -datadir /data/influxb -waldir /data/influxdb/wal
exit
docker cp {{ addon_xxxxx_influxdb }}:/data/exports/influxdb /root/
docker cp /root/influxdb {{ addon_xxxxx_influxdbv2 }}:/data/imports
docker exec -it {{ addon_xxxxx_influxdbv2 }} /bin/bash

influx write \
  --org-id homeassistant \
  --bucket homeassistant \
  --file /data/imports \
  --token {{ TOKEN }}