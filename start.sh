#!/usr/bin/env bash

arch=$(uname -p)
cores="4"
mem="512M"

echo "Starting VM..."

if [ "$arch" == "aarch64" ]
then
    exec qemu-system-aarch64 \
        -nographic \
        -machine virt,highmem=off \
        -cpu cortex-a53 \
        -smp "$cores" \
        -m "$mem" \
        -drive if=virtio,format=qcow2,unit=0,file=balena.qcow2 \
        -net nic,model=virtio,macaddr=52:54:00:b9:57:b8 \
        -net user \
        -netdev user,id=n0,hostfwd=tcp::10022-:22,hostfwd=tcp::12375-:2375 \
        -netdev socket,id=vlan,mcast=230.0.0.1:1234 \
        -device virtio-net-pci,netdev=n0 \
        -device virtio-net-pci,netdev=vlan
elif [ "$arch" == "x86_64" ]
then
    exec qemu-system-x86_64 \
    -nographic \
    -machine q35,accel=kvm \
    -cpu max \
    -smp "$cores" \
    -m "$mem" \
    -drive if=pflash,format=raw,unit=0,file=/usr/share/OVMF/OVMF_CODE.fd \
    -drive if=virtio,format=qcow2,unit=0,file=balena.qcow2 \
    -net nic,model=virtio,macaddr=52:54:00:b9:57:b8 \
    -net user \
    -netdev user,id=n0,hostfwd=tcp::10022-:22,hostfwd=tcp::12375-:2375 \
    -netdev socket,id=vlan,mcast=230.0.0.1:1234 \
    -device virtio-net-pci,netdev=n0 \
    -device virtio-net-pci,netdev=vlan
else
  echo "Architecture not supported."
fi
