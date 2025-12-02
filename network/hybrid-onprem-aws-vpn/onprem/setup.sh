#!/bin/bash
apt update && apt install -y strongswan iproute2
cp /home/ubuntu/ipsec.conf.tmpl /etc/ipsec.conf
cp /home/ubuntu/ipsec.secrets.tmpl /etc/ipsec.secrets
chmod 600 /etc/ipsec.secrets
sysctl -w net.ipv4.ip_forward=1
systemctl restart strongswan
journalctl -u strongswan -f
