WORK_DIR=/opt/openstack-helm

export OS_CLOUD=openstack_helm
export OSH_EXT_NET_NAME="public"
export OSH_VM_FLAVOR="m1.tiny"
export OSH_VM_KEY_STACK="heat-vm-key"
export OSH_PRIVATE_SUBNET="10.0.0.0/24"
export IMAGE_NAME=$(openstack image show -f value -c name \
  $(openstack image list -f csv | awk -F ',' '{ print $2 "," $1 }' | \
    grep "^\"Cirros" | head -1 | awk -F ',' '{ print $2 }' | tr -d '"'))

openstack stack create --wait \
    --parameter public_net=${OSH_EXT_NET_NAME} \
    --parameter image="${IMAGE_NAME}" \
    --parameter ssh_key=${OSH_VM_KEY_STACK} \
    --parameter cidr=${OSH_PRIVATE_SUBNET} \
    -t ${WORK_DIR}/tools/gate/files/heat-basic-vm-deployment.yaml \
    heat-basic-vm-deployment-ocata
