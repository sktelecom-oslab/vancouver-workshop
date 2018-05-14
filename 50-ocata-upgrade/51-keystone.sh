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

for JOBS in keystone-db-init keystone-db-sync keystone-bootstrap keystone-credential-setup keystone-domain-manage keystone-fernet-setup; do
  kubectl --namespace openstack delete job "${JOBS}"
done

tee /tmp/keystone-ocata.yaml <<EOF
images:
  tags:
    bootstrap: docker.io/openstackhelm/heat:ocata
    test: docker.io/kolla/ubuntu-source-rally:ocata
    db_init: docker.io/openstackhelm/heat:ocata
    keystone_db_sync: docker.io/openstackhelm/keystone:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    ks_user: docker.io/openstackhelm/heat:ocata
    rabbit_init: docker.io/rabbitmq:3.7-management
    keystone_fernet_setup: docker.io/openstackhelm/keystone:ocata
    keystone_fernet_rotate: docker.io/openstackhelm/keystone:ocata
    keystone_credential_setup: docker.io/openstackhelm/keystone:ocata
    keystone_credential_rotate: docker.io/openstackhelm/keystone:ocata
    keystone_api: docker.io/openstackhelm/keystone:ocata
    keystone_domain_manage: docker.io/openstackhelm/keystone:ocata
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
    image_repo_sync: docker.io/docker:17.07.0
EOF
helm upgrade keystone ~/vancouver-workshop/openstack-helm/keystone \
    -f /tmp/keystone-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
helm status keystone
export OS_CLOUD=openstack_helm
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack endpoint list
