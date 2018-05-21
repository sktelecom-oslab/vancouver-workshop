# Deploy & Upgrade OpenStack on Kubernetes!

This set of scripts let anyone install openstack-helm on a single machine.

* Kubernetes v1.10.2
* Helm v2.8.2
* Ceph Luminous Version
* Deploy OpenStack Newton release
* Upgrade OpenStack Ocata release

Minimum Hardware (VM) Requirements
* Spec: 4 CPU / 16G MEMORY / 100G DISK / 1 NIC
* OS: Ubuntu 16.04

## Quick Start Guide

### Download Installation Scripts, openstack-helm & openstack-helm-infra source
    $ sudo chown -R ubuntu: /opt
    $ git clone https://github.com/sktelecom-oslab/vancouver-workshop.git \
          /opt/vancouver-workshop
    $ git clone https://github.com/openstack/openstack-helm.git \
         /opt/openstack-helm
    $ cd /opt/openstack-helm; git reset --hard a4fa9b761e2de14df588c1e37f3693174f15ad36
    $ git clone https://github.com/openstack/openstack-helm-infra.git \
         /opt/openstack-helm-infra
    $ cd /opt/openstack-helm-infra; git reset --hard 39e1f7f9f38d6e8b704471acca4e30e912417f28

### Initialize environment and install all related packages using
    $ /opt/openstack-helm/tools/deployment/developer/common/000-install-packages.sh

### Deploy kubernetes cluster at your single machine
    $ /opt/openstack-helm/tools/deployment/developer/common/010-deploy-k8s.sh
    $ /opt/openstack-helm/tools/deployment/developer/common/020-setup-client.sh

### Deploy infra components for OpenStack
    $ cd /opt/vancouver-workshop
    $ ./20-infra/22-ingress.sh
    $ ./20-infra/23-ceph.sh
    $ ./20-infra/24-ceph-ns-activate.sh
    $ ./20-infra/25-mariadb.sh
    $ ./20-infra/26-rabbitmq.sh
    $ ./20-infra/27-memcached.sh
    
### Deploy OpenStack
    $ ./30-newton-deploy/31-keystone.sh
    $ ./30-newton-deploy/32-ceph-radosgateway.sh
    $ ./30-newton-deploy/33-glance.sh
    $ ./30-newton-deploy/34-cinder.sh
    $ ./30-newton-deploy/35-openvswitch.sh
    $ ./30-newton-deploy/36-libvirt.sh
    $ ./30-newton-deploy/37-compute-kit.sh
    $ ./30-newton-deploy/38-heat.sh
    $ ./30-newton-deploy/39-horizon.sh

### Initialize OpenStack and Launch an instance (Virtual Machine)
    $ ./90-common/800-setup-gateway.sh
    $ ./90-common/900-use-it.sh

First, populate environment variables with the location of the Identity service and the admin project and user credentials. This script also creates all the necessary resources to launch an instances and access it.

* Create private network
* Create public network
* Create router
* Add security group for ssh
* Create private key
* Create virtual machine
* Add public ip to vm

### Deploy Monitoring - Prometheus
    $ ./40-prometheus/41-lma-nfs-provisioner.sh
    $ ./40-prometheus/42-prometheus.sh
    $ ./40-prometheus/43-node-exporter.sh
    $ ./40-prometheus/44-openstack-exporter.sh
    $ ./40-prometheus/45-grafana.sh

### Upgrade Openstack - Ocata release
    $ ./50-ocata-upgrade/51-keystone.sh
    $ ./50-ocata-upgrade/52-glance.sh
    $ ./50-ocata-upgrade/53-cinder.sh
    $ ./50-ocata-upgrade/54-neutron.sh
    $ ./50-ocata-upgrade/55-nova.sh
    $ ./50-ocata-upgrade/56-heat.sh
    $ ./50-ocata-upgrade/57-horizon.sh

###  Access Horizon & Grafana
#### Horizon
    http://<HOST_IP>:31000
    domain: default
    admin / password

#### Grafana
    http://<HOST_IP>:30902
    admin / admin

## Appendix

### Acknowledgement

[OpenStack-Helm]: https://github.com/openstack/openstack-helm
[OpenStack-Helm Document]: https://docs.openstack.org/openstack-helm/latest/readme.html


