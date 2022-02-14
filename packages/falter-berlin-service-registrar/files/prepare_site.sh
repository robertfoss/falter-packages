#!/bin/sh

. /lib/config/uci.sh

SITE="testsite"
DESCRIPTION="Testseite zum Testen"
PORT="81"
WWW_PATH="/tmp/www/"
PROTO="tcp"

# load site from source
mkdir -p /tmp/www/${SITE}

# configure site in uhttpd
uci_add uhttpd uhttpd ${SITE}
uci_add_list uhttpd ${SITE} listen_http "0.0.0.0:${PORT}"
uci_add_list uhttpd ${SITE} listen_http "[::]:${PORT}"
uci_set uhttpd ${SITE} home "${WWW_PATH}${SITE}/"
uci_set uhttpd ${SITE} max_requests 5
uci_set uhttpd ${SITE} max_connections 100
uci commit uhttpd

# announce service via olsrd nameservice plugin
#list hosts '10.31.142.65 freifunk-ag'
#list service 'http://freifunk-ag.olsr:81|tcp|Freifunk-AG TUB'

#olsrd.@LoadPlugin[2]=LoadPlugin
#olsrd.@LoadPlugin[2].library='olsrd_nameservice'
#olsrd.@LoadPlugin[2].suffix='.olsr'
#olsrd.@LoadPlugin[2].hosts_file='/tmp/hosts/olsr'
#olsrd.@LoadPlugin[2].latlon_file='/var/run/latlon.js'
#olsrd.@LoadPlugin[2].services_file='/var/etc/services.olsr'
#olsrd.@LoadPlugin[2].ignore='0'
#olsrd.@LoadPlugin[2].hosts='10.31.142.65 freifunk-ag'
#olsrd.@LoadPlugin[2].service='http://freifunk-ag.olsr:81|tcp|Freifunk-AG TUB'


SERVICE_ADDR=$(uci_get network dhcp ipaddr) # first IP-addr of dhcp-subnet

HOSTLINE="${SERVICE_ADDR} ${SITE}"
SERVICE_LINE="http://${SITE}.olsr:${PORT}|${PROTO}|${DESCRIPTION}"

# get number of nameservice_plugin in olsrd-config
NS_PLUGIN=$(uci show olsrd | grep nameservice | sed -e 's|.*\(\d\).*|\1|g')

uci_add_list olsrd @LoadPlugin["$NS_PLUGIN"] hosts "$HOSTLINE"
uci_add_list olsrd @LoadPlugin["$NS_PLUGIN"] service "$SERVICE_LINE"
uci_commit olsrd

/etc/init.d/uhttpd restart
/etc/init.d/olsrd restart
