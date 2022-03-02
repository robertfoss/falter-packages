#!/bin/sh

. /lib/config/uci.sh

SITE="testsite"
DESCRIPTION="Testseite zum Testen"
PORT="81"
WWW_PATH="/tmp/www/"
PROTO="tcp"

# load site from source
mkdir -p /tmp/www/${SITE}

# omit dashes in uci-section
SITE_UCI=$(echo "$SITE" | tr '-' '_' | tr '.' '_')

# configure website in uhttpd
uci_add uhttpd uhttpd "${SITE_UCI}"
uci_add_list uhttpd "${SITE_UCI}" listen_http "0.0.0.0:${PORT}"
uci_add_list uhttpd "${SITE_UCI}" listen_http "[::]:${PORT}"
uci_set uhttpd "${SITE_UCI}" home "${WWW_PATH}${SITE}/"
uci_set uhttpd "${SITE_UCI}" max_requests 5
uci_set uhttpd "${SITE_UCI}" max_connections 100
uci commit uhttpd

SERVICE_ADDR=$(uci_get network dhcp ipaddr) # first IP-addr of dhcp-subnet

HOSTLINE="${SERVICE_ADDR} ${SITE}"
SERVICE_LINE="http://${SITE}.olsr:${PORT}|${PROTO}|${DESCRIPTION}"

# get number of nameservice_plugin in olsrd-config
NS_PLUGIN=$(uci show olsrd | grep nameservice | sed -e 's|.*\(\d\).*|\1|g')

# generate service entry in olsrd-config
uci_add_list olsrd @LoadPlugin["$NS_PLUGIN"] hosts "$HOSTLINE"
uci_add_list olsrd @LoadPlugin["$NS_PLUGIN"] service "$SERVICE_LINE"
uci_commit olsrd

/etc/init.d/uhttpd restart
/etc/init.d/olsrd restart
