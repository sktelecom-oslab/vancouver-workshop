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
set -x
for JOBS in glance-db-init glance-db-sync glance-ks-endpoints glance-ks-service glance-ks-user glance-storage-init; do
  kubectl --namespace openstack delete job "${JOBS}"
done

set -xe
tee /tmp/glance-ocata.yaml <<EOF
images:
  tags:
    test: docker.io/kolla/ubuntu-source-rally:ocata
    glance_storage_init: docker.io/port/ceph-config-helper:v1.10.2
    db_init: docker.io/openstackhelm/heat:ocata
    glance_db_sync: docker.io/openstackhelm/glance:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    ks_user: docker.io/openstackhelm/heat:ocata
    ks_service: docker.io/openstackhelm/heat:ocata
    ks_endpoints: docker.io/openstackhelm/heat:ocata
    rabbit_init: docker.io/rabbitmq:3.7-management
    glance_api: docker.io/openstackhelm/glance:ocata
    glance_registry: docker.io/openstackhelm/glance:ocata
    bootstrap: docker.io/openstackhelm/heat:ocata
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
    image_repo_sync: docker.io/docker:17.07.0
bootstrap:
  enabled: false
EOF
helm upgrade glance ~/vancouver-workshop/openstack-helm/glance \
    -f /tmp/glance-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
helm status glance
export OS_CLOUD=openstack_helm
openstack service list
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack image list
openstack image show 'Cirros 0.3.5 64-bit'
