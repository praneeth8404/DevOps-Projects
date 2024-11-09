#!/bin/bash

KUBERNETES_VERSION='1.30.6-1.1'
ETCD_BACKUP_PATH="/opt/etcd-snapshot-$(date +%Y%m%d%H%M%S).db"

# Function to backup etcd on the control plane node
backup_etcd() {
    echo "Taking an etcd snapshot backup..."
    ETCDCTL_API=3 etcdctl snapshot save $ETCD_BACKUP_PATH \
        --endpoints=https://127.0.0.1:2379 \
        --cacert=/etc/kubernetes/pki/etcd/ca.crt \
        --cert=/etc/kubernetes/pki/etcd/server.crt \
        --key=/etc/kubernetes/pki/etcd/server.key

    if [ $? -eq 0 ]; then
        echo "etcd backup saved successfully at $ETCD_BACKUP_PATH."
    else
        echo "etcd backup failed. Exiting to prevent data loss."
        exit 1
    fi
}

# Function to upgrade kubeadm, kubectl, and kubelet
upgrade_components() {
    echo "Updating kubeadm to version $KUBERNETES_VERSION..."
    apt-get update
    sudo apt-cache madison kubeadm
    sudo apt-mark unhold kubeadm
    sudo apt-get update && sudo apt-get install -y kubeadm=$KUBERNETES_VERSION && sudo apt-mark hold kubeadm

}

# Function to upgrade the control plane
upgrade_control_plane() {
    echo "Upgrading control plane node..."
    kubeadm upgrade apply v$KUBERNETES_VERSION -y
    echo "Control plane upgraded successfully."
}

# Function to update kubelet and kubectl, then restart kubelet service
upgrade_kubelet_kubectl() {
    echo "Updating kubelet and kubectl to version $KUBERNETES_VERSION..."
    sudo apt-mark unhold kubelet kubectl && \
    sudo apt-get install -y kubelet=$KUBERNETES_VERSION kubectl=$KUBERNETES_VERSION && \ sudo apt-mark hold kubelet kubectl
    sudo systemctl daemon-reload
    sudo systemctl restart kubelet
    echo "Kubelet and kubectl upgraded successfully."
}

# Function to drain and uncordon worker nodes
drain_node() {
    echo "Draining node $1..."
    kubectl drain $1 --ignore-daemonsets
}

uncordon_node() {
    echo "Uncordoning node $1..."
    kubectl uncordon $1
}

# Run on Control Plane Node
if [[ $1 == "master" ]]; then
    backup_etcd
    upgrade_components
    upgrade_control_plane
    upgrade_kubelet_kubectl

# Run on Worker Nodes
elif [[ $1 == "worker" ]]; then
    NODE_NAME=$(hostname)
    drain_node $NODE_NAME
    upgrade_components
    kubeadm upgrade node
    upgrade_kubelet_kubectl
    uncordon_node $NODE_NAME
else
    echo "Usage: $0 <master|worker>"
    exit 1
fi

