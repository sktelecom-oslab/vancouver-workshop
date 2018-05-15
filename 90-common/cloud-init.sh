#!/bin/bash
set -ex

echo "ubuntu:openstackhelm" | sudo -H chpasswd
sudo -H sed -i 's|PasswordAuthentication no|PasswordAuthentication yes|g' /etc/ssh/sshd_config
sudo -H systemctl restart sshd

sudo -H su -c 'git clone https://github.com/sktelecom-oslab/vancouver-workshop.git /home/ubuntu/vancouver-workshop' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm /home/ubuntu/vancouver-workshop/openstack-helm' ubuntu
sudo -H su -c 'git clone https://git.openstack.org/openstack/openstack-helm-infra /home/ubuntu/vancouver-workshop/openstack-helm-infra' ubuntu
sudo -H su -c 'cd /home/ubuntu/vancouver-workshop/openstack-helm; ./tools/deployment/developer/common/000-install-packages.sh; ./tools/deployment/developer/common/000-install-packages.sh; ./tools/deployment/developer/common/010-deploy-k8s.sh; ./tools/deployment/developer/common/020-setup-client.sh' ubuntu
sudo -H su -c '(cd /home/ubuntu/vancouver-workshop/openstack-helm; make all pull-all-images)' ubuntu
sudo -H su -c '(cd /home/ubuntu/vancouver-workshop/openstack-helm-infra; make all pull-all-images)' ubuntu
