#!/command/with-contenv bashio
# ==============================================================================
# Home Assistant Community Add-on: InfluxDBv2
# Configures Traefik for use with the InfluxDB v2
# ==============================================================================
declare port
declare certfile
declare ingress_interface
declare ingress_port
declare ingress_entry
declare keyfile

certfile=$(bashio::config 'certfile')
keyfile=$(bashio::config 'keyfile')
ingress_port=$(bashio::addon.ingress_port)
port=$(bashio::addon.port 8086)
ingress_interface=$(bashio::addon.ip_address)
ingress_entry=$(bashio::addon.ingress_entry)

sed -i "s#%%certfile%%#${certfile}#g" /etc/traefik/traefik.yaml
sed -i "s#%%keyfile%%#${keyfile}#g" /etc/traefik/traefik.yaml

sed -i "s/%%ingress_port%%/${ingress_port}/g" /etc/traefik/traefik.yaml
sed -i "s/%%port%%/${port}/g" /etc/traefik/traefik.yaml
sed -i "s/%%interface%%/${ingress_interface}/g" /etc/traefik/traefik.yaml
sed -i "s#%%ingress_entry%%#${ingress_entry}#g" /etc/traefik/traefik.yaml