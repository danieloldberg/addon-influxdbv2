#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDBv2
# Ensure a user for Chronograf & Kapacitor exists within InfluxDBv2
# ==============================================================================
declare secret

# If secret file exists, skip this script
if bashio::fs.file_exists "/data/secret"; then
    exit 0
fi

# Generate secret based on the Hass.io token
secret="${SUPERVISOR_TOKEN:21:32}"

exec 3< <(influxd)

sleep 3

for i in {1800..0}; do
    if influx ping > /dev/null 2>&1; then
        break;
    fi
    bashio::log.info "InfluxDB init process in progress..."
    sleep 5
done

if [[ "$i" = 0 ]]; then
    bashio::exit.nok "InfluxDB init process failed."
fi

influx setup \
    --username chronograf \
    --password $secret \
    --token $secret \
    --org homeassistant \
    --bucket homeassistant \
    --force \
    &> /dev/null || true

# influx org create -n homeassistant \
#    &> /dev/null || true

#influx -execute \
#    "CREATE USER chronograf WITH PASSWORD '${secret}'" \
#         &> /dev/null || true

#influx user create -n chronograf -p $secret -o homeassistant\
#    &> /dev/null || true

#influx -execute \
#    "SET PASSWORD FOR chronograf = '${secret}'" \
#         &> /dev/null || true

#influx -execute \
#    "GRANT ALL PRIVILEGES TO chronograf" \
#        &> /dev/null || true

#influx -execute \
#    "CREATE USER kapacitor WITH PASSWORD '${secret}'" \
        #&> /dev/null || true

influx user create -n kapacitor -p $secret -o homeassistant\
    &> /dev/null || true

#influx -execute \
#    "SET PASSWORD FOR kapacitor = '${secret}'" \
#        &> /dev/null || true

#influx -execute \
#    "GRANT ALL PRIVILEGES TO kapacitor" \
#        &> /dev/null || true

kill "$(pgrep influxd)" >/dev/null 2>&1

# Save secret for future use
echo "${secret}" > /data/secret
