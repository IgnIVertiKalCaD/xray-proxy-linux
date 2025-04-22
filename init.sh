#!/bin/bash

mkdir /etc/xray/
cp config.json /etc/xray

mkdir /etc/nftables.d/
cp proxy.conf /etc/nftables.d

cp xray-proxy.nix /etc/nixos/

echo "cool. Run nixos-rebuild test"
