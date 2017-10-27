# Openstack Ansible Installation

This playbook provides the deployment of Openstack OCATA software on Ubuntu 16 server.


## How to run

With rsa key set
```sh
ansible-playbook -i inventory site.yml
```

With password
```sh
ansible-playbook -i inventory site.yml --ask-pass --ask-sudo-pass
```

## Files to edit

**File 1.** group_vars/all:

```yml

GLOB_OS_SSH_USERNAME: root
GLOB_OS_PYTHON_VENV: /root/ansible_venv/bin/

# TODO; Not implemented yet
dns_domain:

########## Variables to edit - START ##############################

controller_management_ip: 10.143.143.110
controller_management_interface: enp6s0
controller_provider_ip: 10.100.16.20
controller_provider_interface: enp4s0f0
controller_overlay_ip: 192.168.0.1
controller_overlay_interface: enp4s0f1
controller_hostname: charController


compute1_management_ip: 10.143.143.111
compute1_management_interface: eno2
compute1_overlay_ip: 192.168.0.2
compute1_overlay_interface: enp5s0f0
compute1_hostname: charCompute1

compute2_management_ip: 10.143.143.112
compute2_openstack_ip: 192.168.0.3
compute2_hostname: charCompute2

api_password: *******

# Management Interface Parameters for all controller nodes
management_cidr: 10.143.143.0/24
management_netmask: 255.255.255.0
management_gateway: 10.143.143.254
management_dns_nameservers: "10.30.0.11 8.8.8.8 8.8.4.4"

# Provider Interface Parameters for all controller nodes
provider_cidr: 10.100.16.0/20
provider_netmask: 255.255.240.0
provider_gateway: 10.100.16.1
provider_dns_nameservers: "10.30.0.11 8.8.8.8 8.8.4.4"

provider_pool_start: 10.100.16.21
provider_pool_end: 10.100.16.99

# Overlay Interface Parameters for all controller nodes
overlay_netmask: 255.255.255.0

keystone_db_pass: KEYSTONE_DBPASS
glance_db_pass: GLANCE_DBPASS
nova_db_pass: NOVA_DBPASS
neutron_db_pass: NEUTRON_DBPASS
heat_db_pass: HEAT_DBPASS

metadata_secret: METADATA_SECRET
rabbit_pass: RABBIT_PASS

openstack_auth:
  auth_url: 'http://controller:35357/v3'
  project_domain_id: 'default'
  user_domain_id: 'default'
  username: 'admin'
  password: '{{ api_password }}'
  project_name: 'admin'


environment_variables:
  OS_PROJECT_DOMAIN_NAME: 'default'
  OS_USER_DOMAIN_NAME: 'default'
  OS_PROJECT_NAME: 'admin'
  OS_USERNAME: 'admin'
  OS_PASSWORD: '{{ api_password }}'
  OS_AUTH_URL: 'http://controller:35357/v3'
# These are important for os_.. ansible modules authentication
  OS_IDENTITY_API_VERSION: '3'
  OS_IMAGE_API_VERSION: '2'

########## Variables to edit  - END ##############################

# TODO;  DO NOT CHANGE VALUES!
mysql_user: root
mysql_password:
##############################
```

**File 2.** inventory: Edit the IPs so that they correspond to the available servers (eg. 10.30.0.201)
```yml
# Only one node to be entered here
[controller_nodes]
10.143.143.110 ansible_user="{{ GLOB_OS_SSH_USERNAME }}" management_interface="{{ controller_management_interface }}" management_ip="{{ controller_management_ip }}" overlay_interface="{{ controller_overlay_interface }}" overlay_ip="{{ controller_overlay_ip }}" hostname="{{ controller_hostname }}" provider_interface="{{ controller_provider_interface }}" provider_ip="{{ controller_provider_ip }}"

# Any number of nodes to be entered here
[compute_nodes]
10.143.143.111 ansible_user="{{ GLOB_OS_SSH_USERNAME }}" management_interface="{{ compute1_management_interface }}" management_ip="{{ compute1_management_ip }}" overlay_interface="{{ compute1_overlay_interface }}" overlay_ip="{{ compute1_overlay_ip }}" hostname="{{ compute1_hostname }}"


[all_hosts:children]
controller_nodes
compute_nodes

```

