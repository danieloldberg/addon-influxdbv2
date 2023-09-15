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

## Authors & contributors

Author of this repository is [Daniel Oldberg](https://github.com/danieloldberg/).
Huge credits to Franck Nijhof and Home assistant community for their work on the original InfluxDB project that was used as a baseline.

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
