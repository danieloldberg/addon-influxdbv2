# Add-on: InfluxDB v2

InfluxDB v2 in Home Assistant, **almost** just like the https://community.home-assistant.io/t/home-assistant-community-add-on-influxdb/54491.

InfluxDB v2 is an open source time series database optimized for high-write-volume.
It's useful for recording metrics, sensor data, events,
and performing analytics. It exposes an HTTP API for client interaction and is
often used in combination with Grafana to visualize the data.

InfluxDB v2 comes with its own admin interface for managing your users, databases,
data retention settings, and lets you peek inside the database.

## Installation

The installation of this add-on is pretty straightforward and not different in comparison to installing any other Home Assistant add-on.

1. Click the Home Assistant My button below to open the add-on on your Home
   Assistant instance.

   [![Open this add-on in your Home Assistant instance.][addon-badge]][addon]

1. Click the "Install" button to install the add-on.
1. Start the "InfluxDB v2" add-on.
1. Check the logs of the "InfluxDB" to see if everything went well.

## Configuration

**Note**: _Remember to restart the add-on when the configuration is changed._

Currently only supports HTTP and limited configuration options. SSL/TLS & other options are in the backlog.

Example add-on configuration:

```yaml
Ports:
  - InfluxDB server: 8086 (8086/tcp)
```

## Integrating into Home Assistant

The `influxdb` integration of Home Assistant makes it possible to transfer all state changes to an InfluxDB database.

You need to do the following steps in order to get this working:

- Browse to http://{{ HOME_ASSISTANT_URL }}:8086 `(replace {{ HOME_ASSISTANT_URL }} with the address to your home assistant installation)`
- Go through the onboarding process by creating a default user, password, organization and bucket.
- Save the operator token for future use. Note: It's best to create a separate user and token to be used in home assistant. Operator token has unlimited permissions to your InfluxDB installation.

Now we've got this in place, add the following snippet to your Home Assistant `configuration.yaml` file.

```yaml
influxdb:
  api_version: 2
  ssl: false
  host: a0d7b954-influxdb
  port: 8086
  token: GENERATED_AUTH_TOKEN
  organization: RANDOM_16_DIGIT_HEX_ID
  bucket: BUCKET_NAME
  tags:
    source: HA
  tags_attributes:
    - friendly_name
  default_measurement: units
  exclude:
    entities:
      - zone.home
    domains:
      - persistent_notification
      - person
  include:
    domains:
      - sensor
      - binary_sensor
      - sun
    entities:
      - weather.home
```

Restart Home Assistant.

You should now see the data flowing into InfluxDB by visiting the web-interface and using the Data Explorer.

Full details of the Home Assistant integration can be found here:

<https://www.home-assistant.io/integrations/influxdb/>

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
influx_inspect export -database homeassistant -retention autogen -out /data/exports/influxdb -lponly -datadir /data/influxb -waldir /data/influxdb/wal # Export the influxdb timeseries data
exit # Exit container to host
docker cp {{ addon_xxxxx_influxdb }}:/data/exports/influxdb /root/ # Copy the backup to host
docker cp /root/influxdb {{ addon_xxxxx_influxdbv2 }}:/data/imports # Copy the backup to the v2 container (Make sure it's started)
docker exec -it {{ addon_xxxxx_influxdbv2 }} /bin/bash # Enter the v2 container. Replace addon_xxxxx_influxdbv2 with the v2 Id
influx write \
  --org-id homeassistant \
  --bucket homeassistant \
  --file /data/imports \
  --token {{ TOKEN }} # Replace {{ TOKEN }} with your homeassistant/operator token.
```

## Authors & contributors

Author of this repository is [Daniel Oldberg](https://github.com/danieloldberg/).
Huge credits to Franck Nijhof and Home assistant community for their work on the original InfluxDB project that was used as a foundation.

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

[addon-badge]: https://my.home-assistant.io/badges/supervisor_addon.svg
[addon]: https://my.home-assistant.io/redirect/supervisor_add_addon_repository/?repository_url=https%3A%2F%2Fgithub.com%2Fdanieloldberg%2Faddon-influxdbv2
[forum]: https://community.home-assistant.io/t/home-assistant-community-add-on-influxdb/54491?u=frenck
[issue]: https://github.com/danieloldberg/addon-influxdbv2/issues
[reddit]: https://reddit.com/r/homeassistant
