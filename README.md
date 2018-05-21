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

### Kubernetes and Common Setup
    $ cd /opt/openstack-helm
    $ ./tools/deployment/developer/common/000-install-packages.sh
    $ ./tools/deployment/developer/common/010-deploy-k8s.sh
    $ ./tools/deployment/developer/common/020-setup-client.sh

### Deploy OpenStack With Ceph
    $ cd /opt/openstack-helm
    $ ./tools/deployment/developer/ceph/030-ingress.sh
    $ ./tools/deployment/developer/ceph/040-ceph.sh
    $ ./tools/deployment/developer/ceph/045-ceph-ns-activate.sh
    $ ./tools/deployment/developer/ceph/050-mariadb.sh
    $ ./tools/deployment/developer/ceph/060-rabbitmq.sh
    $ ./tools/deployment/developer/ceph/070-memcached.sh
    $ ./tools/deployment/developer/ceph/080-keystone.sh
    $ ./tools/deployment/developer/ceph/090-heat.sh
    $ ./tools/deployment/developer/ceph/100-horizon.sh
    $ ./tools/deployment/developer/ceph/110-ceph-radosgateway.sh
    $ ./tools/deployment/developer/ceph/120-glance.sh
    $ ./tools/deployment/developer/ceph/130-cinder.sh
    $ ./tools/deployment/developer/ceph/140-openvswitch.sh
    $ ./tools/deployment/developer/ceph/150-libvirt.sh
    $ ./tools/deployment/developer/ceph/160-compute-kit.sh
    $ ./tools/deployment/developer/ceph/170-setup-gateway.sh
    $ ./tools/deployment/developer/ceph/900-use-it.sh

### Exercise the Cloud
    $ ./tools/deployment/developer/ceph/900-use-it.sh

First, populate environment variables with the location of the Identity service and the admin project and user credentials. This script also creates all the necessary resources to launch an instances and access it.

* Create private network
* Create public network
* Create router
* Add security group for ssh
* Create private key
* Create virtual machine
* Add public ip to vm

### Deploy Monitoring - Prometheus
    $ cd /opt/vancouver-workshop
    $ ./40-prometheus/41-lma-nfs-provisioner.sh
    $ ./40-prometheus/42-prometheus.sh
    $ ./40-prometheus/43-node-exporter.sh
    $ ./40-prometheus/44-openstack-exporter.sh
    $ ./40-prometheus/45-grafana.sh

### Upgrade Openstack - Ocata release
    $ cd /opt/vancouver-workshop
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


