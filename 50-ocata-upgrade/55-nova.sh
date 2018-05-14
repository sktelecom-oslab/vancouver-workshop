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

#for JOBS in nova-bootstrap nova-cell-setup nova-db-init nova-db-sync nova-ks-endpoints nova-ks-service nova-ks-user placement-ks-endpoints placement-ks-service placement-ks-user; do
#  kubectl --namespace openstack delete job "${JOBS}"
#done

tee /tmp/nova-ocata.yaml <<EOF
images:
  tags:
    bootstrap: docker.io/openstackhelm/heat:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    db_init: docker.io/openstackhelm/heat:ocata
    dep_check: 'quay.io/stackanetes/kubernetes-entrypoint:v0.3.1'
    rabbit_init: docker.io/rabbitmq:3.7-management
    ks_user: docker.io/openstackhelm/heat:ocata
    ks_service: docker.io/openstackhelm/heat:ocata
    ks_endpoints: docker.io/openstackhelm/heat:ocata
    nova_api: docker.io/openstackhelm/nova:ocata
    nova_cell_setup: docker.io/openstackhelm/nova:ocata
    nova_cell_setup_init: docker.io/openstackhelm/heat:ocata
    nova_compute: docker.io/openstackhelm/nova:ocata
    nova_compute_ironic: 'docker.io/kolla/ubuntu-source-nova-compute-ironic:3.0.3'
    nova_compute_ssh: docker.io/openstackhelm/nova:ocata
    nova_conductor: docker.io/openstackhelm/nova:ocata
    nova_consoleauth: docker.io/openstackhelm/nova:ocata
    nova_db_sync: docker.io/openstackhelm/nova:ocata
    nova_novncproxy: docker.io/openstackhelm/nova:ocata
    nova_novncproxy_assets: 'docker.io/kolla/ubuntu-source-nova-novncproxy:3.0.3'
    nova_placement: docker.io/openstackhelm/nova:ocata
    nova_scheduler: docker.io/openstackhelm/nova:ocata
    nova_spiceproxy: docker.io/openstackhelm/nova:ocata
    nova_spiceproxy_assets: 'docker.io/kolla/ubuntu-source-nova-spicehtml5proxy:3.0.3'
    test: 'docker.io/kolla/ubuntu-source-rally:ocata'
bootstrap:
  enabled: false
EOF
if [ "x$(systemd-detect-virt)" == "xnone" ]; then
  echo 'OSH is not being deployed in virtualized environment'
  helm upgrade nova ~/vancouver-workshop/openstack-helm/nova \
      -f /tmp/nova-ocata.yaml
else
  echo 'OSH is being deployed in virtualized environment, using qemu for nova'
  helm upgrade nova ~/vancouver-workshop/openstack-helm/nova \
      -f /tmp/nova-ocata.yaml \
      --set conf.nova.libvirt.virt_type=qemu
fi

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack compute service list
