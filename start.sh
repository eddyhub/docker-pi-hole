#!/bin/bash -e
# Dockerfile variables
export TAG
export ServerIP
export ServerIPv6
export PYTEST
export PHP_ENV_CONFIG
export PHP_ERROR_LOG 
export HOSTNAME
export WEBLOGDIR
export DNS1
export DNS2
export INTERFACE
export IPv6
export WEBPASSWORD
export WEB_PORT
export DHCP_ACTIVE
export DHCP_START
export DHCP_END
export DHCP_ROUTER
export DHCP_LEASETIME
export PIHOLE_DOMAIN
export DHCP_IPv6

. /bash_functions.sh

echo " ::: Starting docker specific setup for docker diginc/pi-hole"
validate_env || exit 1
prepare_setup_vars
change_setting "IPV4_ADDRESS" "$ServerIP"
change_setting "IPV6_ADDRESS" "$ServerIPv6"
setup_web_port "$WEB_PORT"
setup_web_password "$WEBPASSWORD"
setup_dnsmasq "$DNS1" "$DNS2" "$DHCP_ACTIVE" "$DHCP_START" "$DHCP_END" "$DHCP_ROUTER" "$DHCP_LEASETIME" "$PIHOLE_DOMAIN" "$DHCP_IPv6"
setup_php_env
setup_dnsmasq_hostnames "$ServerIP" "$ServerIPv6" "$HOSTNAME"
setup_ipv4_ipv6
setup_lighttpd_bind "$ServerIP" "$TAG"
test_configs
test_framework_stubbing

[ -f /.piholeFirstBoot ] && rm /.piholeFirstBoot

echo "::: Docker start setup complete"
