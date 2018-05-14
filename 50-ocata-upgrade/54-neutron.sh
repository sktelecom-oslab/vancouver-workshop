#!/bin/bash

# Copyright 2017 The Openstack-Helm Authors.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
set -xe

for JOBS in neutron-db-init neutron-db-sync neutron-ks-endpoints neutron-ks-service neutron-ks-user; do
  kubectl --namespace openstack delete job "${JOBS}"
done

tee /tmp/neutron-ocata.yaml <<EOF
images:
  tags:
    bootstrap: docker.io/openstackhelm/heat:ocata
    test: docker.io/kolla/ubuntu-source-rally:ocata
    db_init: docker.io/openstackhelm/heat:ocata
    neutron_db_sync: docker.io/openstackhelm/neutron:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    rabbit_init: docker.io/rabbitmq:3.7-management
    ks_user: docker.io/openstackhelm/heat:ocata
    ks_service: docker.io/openstackhelm/heat:ocata
    ks_endpoints: docker.io/openstackhelm/heat:ocata
    neutron_server: docker.io/openstackhelm/neutron:ocata
    neutron_dhcp: docker.io/openstackhelm/neutron:ocata
    neutron_metadata: docker.io/openstackhelm/neutron:ocata
    neutron_l3: docker.io/openstackhelm/neutron:ocata
    neutron_openvswitch_agent: docker.io/openstackhelm/neutron:ocata
    neutron_linuxbridge_agent: docker.io/openstackhelm/neutron:ocata
    neutron_sriov_agent: docker.io/openstackhelm/neutron:ocata-sriov-1804
    neutron_sriov_agent_init: docker.io/openstackhelm/neutron:ocata-sriov-1804
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
bootstrap:
  enabled: false
network:
  interface:
    tunnel: docker0
conf:
  neutron:
    DEFAULT:
      l3_ha: False
      min_l3_agents_per_router: 1
      max_l3_agents_per_router: 1
      l3_ha_network_type: vxlan
      dhcp_agents_per_network: 1
  plugins:
    ml2_conf:
      ml2_type_flat:
        flat_networks: public
    #NOTE(portdirect): for clarity we include options for all the neutron
    # backends here.
    openvswitch_agent:
      agent:
        tunnel_types: vxlan
      ovs:
        bridge_mappings: public:br-ex
    linuxbridge_agent:
      linux_bridge:
        bridge_mappings: public:br-ex
EOF
helm upgrade neutron ~/vancouver-workshop/openstack-helm/neutron \
    -f /tmp/neutron-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack network agent list
