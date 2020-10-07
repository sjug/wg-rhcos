#!/bin/bash
set -ex

KERNEL_VERSION=$(uname -r)
KERNEL_CORE=$(find /tmp/overlay -name kernel-core-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_DEVEL=$(find /tmp/overlay -name kernel-devel-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)
KERNEL_HEADERS=$(find /tmp/overlay -name kernel-headers-${KERNEL_VERSION}.rpm -exec ls {} \; | tail -n1)

if [ -z "${KERNEL_CORE}" ] || [ -z "${KERNEL_DEVEL}" ] || [ -z "${KERNEL_HEADERS}" ]; then
  KERNEL_CORE=kernel-core-${KERNEL_VERSION}
  KERNEL_DEVEL=kernel-devel-${KERNEL_VERSION}
  KERNEL_HEADERS=kernel-headers-${KERNEL_VERSION}
fi

dnf install -y --enablerepo=rhocp-4.3-for-rhel-8-x86_64-rpms $KERNEL_DEVEL $KERNEL_HEADERS $KERNEL_CORE

dnf install -y kmod-wireguard wireguard-tools

#systemctl enable --now wg-quick@wg0.service
wg-quick up wg0
