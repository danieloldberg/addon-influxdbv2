#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDBv2
# Configures InfluxDBv2
# ==============================================================================

# Configures usage reporting to InfluxDB
if bashio::config.false 'reporting'; then
    sed -i 's/reporting-disabled=.*/reporting-disabled=true/' /etc/influxdb/influxdb.conf
    bashio::log.info "Reporting of usage stats to InfluxData is disabled."
fi
