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

for JOBS in horizon-db-init horizon-db-sync; do
  kubectl --namespace openstack delete job "${JOBS}"
done

tee /tmp/horizon-ocata.yaml <<EOF
images:
  tags:
    db_init: docker.io/openstackhelm/heat:ocata
    horizon_db_sync: docker.io/openstackhelm/horizon:ocata
    db_drop: docker.io/openstackhelm/heat:ocata
    horizon: docker.io/openstackhelm/horizon:ocata
    dep_check: quay.io/stackanetes/kubernetes-entrypoint:v0.3.1
bootstrap:
  enabled: false
EOF
helm upgrade horizon ~/vancouver-workshop/openstack-helm/horizon \
    -f /tmp/horizon-ocata.yaml

#NOTE: Wait for deploy
bash ~/vancouver-workshop/90-common/wait-for-pods.sh openstack

#NOTE: Validate Deployment info
helm status horizon
