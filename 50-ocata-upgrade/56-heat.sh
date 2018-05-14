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

for JOBS in heat-bootstrap heat-db-init heat-db-sync heat-domain-ks-user heat-ks-endpoints heat-ks-service heat-ks-user heat-trustee-ks-user heat-trusts; do
  kubectl --namespace openstack delete job "${JOBS}"
done

tee /tmp/heat-ocata.yaml <<EOF
images:
  tags:
    bootstrap: docker.io/openstackhelm/heat:ocata
    db_init: docker.io/openstackhelm/heat:ocata
    heat_db_sync: docker.io/openstackhelm/heat:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    rabbit_init: docker.io/rabbitmq:3.7-management
    ks_user: docker.io/openstackhelm/heat:ocata
    ks_service: docker.io/openstackhelm/heat:ocata
    ks_endpoints: docker.io/openstackhelm/heat:ocata
    heat_api: docker.io/openstackhelm/heat:ocata
    heat_cfn: docker.io/openstackhelm/heat:ocata
    heat_cloudwatch: docker.io/openstackhelm/heat:ocata
    heat_engine: docker.io/openstackhelm/heat:ocata
    heat_engine_cleaner: docker.io/openstackhelm/heat:ocata
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
bootstrap:
  enabled: false
EOF
helm upgrade heat ~/vancouver-workshop/openstack-helm/heat \
    -f /tmp/heat-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
export OS_CLOUD=openstack_helm
openstack service list
sleep 30 #NOTE(portdirect): Wait for ingress controller to update rules and restart Nginx
openstack orchestration service list
