#!/bin/bash
sudo -H apt-get update
sudo -H apt-get install -y git jq nmap python-pip 
sudo -H pip install -U pip==9.0.3
sudo -H pip install python-openstackclient python-heatclient
sudo -H su -c 'git clone https://github.com/sktelecom-oslab/vancouver-workshop.git /home/ubuntu/vancouver-workshop' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm /home/ubuntu/vancouver-workshop/openstack-helm' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm-infra /home/ubuntu/vancouver-workshop/openstack-helm-infra' ubuntu
sudo -H su -c '/home/ubuntu/vancouver-workshop/openstack-helm-infra/tools/gate/devel/start.sh' ubuntu
sudo -H su -c '(cd /home/ubuntu/vancouver-workshop/openstack-helm; make; sudo -H ./tools/pull-images.sh "ceph-client ceph-mon ceph-osd cinder etcd glance heat horizon ingress keystone libvirt mariadb memcached neutron nova openvswitch rabbitmq")' ubuntu
sudo -H su -c '(cd /home/ubuntu/vancouver-workshop/openstack-helm-infra; make; sudo -H ./tools/pull-images.sh "grafana helm-toolit prometheus prometheus-node-exporter prometheus-openstack-exporter")' ubuntu

sudo -H mkdir -p /etc/openstack
cat << EOF | sudo -H tee -a /etc/openstack/clouds.yaml
clouds:
  openstack_helm:
    region_name: RegionOne
    identity_api_version: 3
    auth:
      username: 'admin'
      password: 'password'
      project_name: 'admin'
      project_domain_name: 'default'
      user_domain_name: 'default'
      auth_url: 'http://keystone.openstack.svc.cluster.local/v3'
EOF
sudo -H chown -R ubuntu: /etc/openstack
