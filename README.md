# Home Assistant Community Add-on: InfluxDB v2

Scalable datastore for metrics, events, and real-time analytics.

## About

InfluxDB is an open source time series database optimized for high-write-volume.
It's useful for recording metrics, sensor data, events,
and performing analytics. It exposes an HTTP API for client interaction and is
often used in combination with Grafana to visualize the data.

![InfluxDB v2 frontend](images/screenshot.png)

Compared to InfluxDB v1, v2 comes with a graphical administration interface which
gives you management capabilities of users, databases,
data retention settings, and lets you peek inside the database using the
Data Explorer.

[Read the full add-on documentation](https://github.com/danieloldberg/addon-influxdbv2/blob/main/influxdb/DOCS.md)

## Known issues and limitations

- No SSL.
- This InfluxDB v2 addon currently does not support Home Assistant web access, in other terms the ingress. Reason is that InfluxDB v2 does not support path-based reverse proxies, leading to technical challenges.

## FAQ

### Migrating from InfluxDB v1 to v2 (intermediate difficult level)

To migrate from InfluxDB (hass community addon), easiest is to use [Advanced SSH & Web Terminal
](https://home.danieloldberg.se/hassio/addon/a0d7b954_ssh/info) addon with Protection mode disabled. You're then able to execute docker commands with elevated permissions.

**Please note**: Using the following mentioned methods may impact and/or destroy your entire Home Assistant installation if you don't know what you're doing. Please take appropriate precautions like backups and reading up on the machanics before proceeding.

```bash
docker ps -a # Descibe the containers running and finding the Ids.
docker exec -it {{ addon_xxxxx_influxdb }} /bin/bash # Enter the v1 container. Replace addon_xxxxx_influxdb with the v1 Id
influx_inspect export -compress -database homeassistant -out /data/exports/influxdb.gz -lponly -datadir /data/influxdb/data -waldir /data/influxdb/wal # Export the influxdb timeseries data
exit # Exit container to host
docker cp {{ addon_xxxxx_influxdb }}:/data/exports/influxdb.gz /root/ # Copy the backup to host
docker cp /root/influxdb.gz {{ addon_xxxxx_influxdbv2 }}:/data/influxdb.gz # Copy the backup to the v2 container (Make sure it's started)
docker exec -it {{ addon_xxxxx_influxdbv2 }} /bin/bash # Enter the v2 container. Replace addon_xxxxx_influxdbv2 with the v2 Id
influx write \
  --org-id homeassistant \
  --bucket homeassistant \
  --file /data/influxdb.gz \
  --token {{ TOKEN }} # Replace {{ TOKEN }} with your homeassistant/operator token.
rm /data/influxdb.gz # Remove backup from v2 container
exit
rm /influxdb.gz # Remove backup from host
```

## Authors & contributors

Author of this repository is [Daniel Oldberg](https://github.com/danieloldberg/).
Huge credits to Franck Nijhof and Home assistant community for their work on the original InfluxDB project that was used as the foundation.

## License

MIT License

Copyright (c) 2018-2023

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
