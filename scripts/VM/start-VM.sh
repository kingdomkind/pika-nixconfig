#!/usr/bin/env bash
LIBVIRT_DEFAULT_URI=qemu:///system virsh net-start default
LIBVIRT_DEFAULT_URI=qemu:///system virsh start "Windows-GPU"
