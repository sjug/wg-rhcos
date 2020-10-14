#!/bin/bash
set -ex

RHOCP_VERSION=$(awk -F'"' '/VERSION_ID/{print $2}' /etc/os-release)
SERVER_IP=${SERVER_IP:-192.168.111.1}
DNS_IP=${DNS_IP:-192.168.222.1}
KERNEL_VERSION=$(uname -r)
KERNEL_CORE=$(find /tmp/overlay -name kernel-core-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_DEVEL=$(find /tmp/overlay -name kernel-devel-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_HEADERS=$(find /tmp/overlay -name kernel-headers-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)

catch() {
  cp /etc/resolv.conf.bak /etc/resolv.conf
  wg-quick down wg0
}

set_dns() {
  cp /etc/resolv.conf /etc/resolv.conf.bak
  printf 'nameserver %s\n' "${DNS_IP}" > /etc/resolv.conf
}

if [ -z "${KERNEL_CORE}" ] || [ -z "${KERNEL_DEVEL}" ] || [ -z "${KERNEL_HEADERS}" ]; then
  KERNEL_CORE=kernel-core-${KERNEL_VERSION}
  KERNEL_DEVEL=kernel-devel-${KERNEL_VERSION}
  KERNEL_HEADERS=kernel-headers-${KERNEL_VERSION}
fi

dnf install -y --enablerepo=rhocp-${RHOCP_VERSION}-for-rhel-8-x86_64-rpms ${KERNEL_DEVEL} ${KERNEL_HEADERS} ${KERNEL_CORE}
dnf install -y iproute iputils kmod-wireguard wireguard-tools
dnf clean packages

modprobe wireguard
trap catch err exit
wg-quick up wg0
set_dns
ping -c 3 ${SERVER_IP}
wg

sleep 86400
