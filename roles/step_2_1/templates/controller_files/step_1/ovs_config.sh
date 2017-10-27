#!/usr/bin/env bash

ovs-vsctl add-br br-provider
sleep 2
ovs-vsctl add-port br-provider {{ provider_interface }}
sleep 2
ifconfig br-provider {{ provider_ip }}/24 up
#sleep 2
# might not be needed now
#ip link set br-provider promisc on


