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
for JOBS in cinder-backup-storage-init cinder-bootstrap cinder-db-init cinder-db-sync cinder-ks-endpoints cinder-ks-service cinder-ks-user cinder-storage-init; do
  kubectl --namespace openstack delete job "${JOBS}"
done

set -xe
tee /tmp/cinder-ocata.yaml <<EOF
images:
  tags:
    test: docker.io/kolla/ubuntu-source-rally:ocata
    db_init: docker.io/openstackhelm/heat:ocata
    cinder_db_sync: docker.io/openstackhelm/cinder:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    rabbit_init: docker.io/rabbitmq:3.7-management
    ks_user: docker.io/openstackhelm/heat:ocata
    ks_service: docker.io/openstackhelm/heat:ocata
    ks_endpoints: docker.io/openstackhelm/heat:ocata
    cinder_api: docker.io/openstackhelm/cinder:ocata
    bootstrap: docker.io/openstackhelm/heat:ocata
    cinder_scheduler: docker.io/openstackhelm/cinder:ocata
    cinder_volume: docker.io/openstackhelm/cinder:ocata
    cinder_volume_usage_audit: docker.io/openstackhelm/cinder:ocata
    cinder_storage_init: docker.io/port/ceph-config-helper:v1.10.2
    cinder_backup: docker.io/openstackhelm/cinder:ocata
    cinder_backup_storage_init: docker.io/port/ceph-config-helper:v1.10.2
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
    image_repo_sync: docker.io/docker:17.07.0
bootstrap:
  enabled: false
conf:
  ceph:
    pools:
      backup:
        replication: 1
        crush_rule: same_host
        chunk_size: 8
      volume:
        replication: 1
        crush_rule: same_host
        chunk_size: 8
EOF
helm upgrade cinder ~/vancouver-workshop/openstack-helm/cinder \
    -f /tmp/cinder-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack volume type list
