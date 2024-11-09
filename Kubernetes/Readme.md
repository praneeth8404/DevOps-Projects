This Bash script automates the backup and upgrade process for a Kubernetes cluster, including the control plane and worker nodes. The script ensures a smooth, incremental upgrade while preserving existing configurations and data with an etcd snapshot.

Prerequisites
Ensure you have sudo privileges on the nodes you’re upgrading.
The Kubernetes version is defined as 1.30.6-1.1 in the script, but it can be updated as necessary.
This script is intended for systems using apt as the package manager.
Script Details
File: upgrade_kubernetes.sh
Usage: Run this script on both the control plane and worker nodes.
bash
Copy code
./upgrade_kubernetes.sh <master|worker>
Arguments
master: Executes backup and upgrade for the control plane node.
worker: Upgrades Kubernetes components and kubelet on worker nodes.
Script Workflow
etcd Backup (Control Plane Node):

The backup_etcd function creates a snapshot of etcd for disaster recovery, saving it at /opt/etcd-snapshot-<timestamp>.db.
Component Upgrades:

The upgrade_components function upgrades kubeadm to the specified version.
Control Plane Upgrade:

The upgrade_control_plane function upgrades the control plane, applying any necessary changes.
kubelet and kubectl Upgrade:

The upgrade_kubelet_kubectl function upgrades both kubelet and kubectl to the specified version and restarts kubelet.
Node Management (Worker Nodes Only):

The script drains the worker node, performs the upgrade, and then uncordons the node to restore it to normal operation.
Instructions for Usage
On Control Plane Node:

bash
Copy code
./upgrade_kubernetes.sh master
On Each Worker Node:

bash
Copy code
./upgrade_kubernetes.sh worker
Example Output
Successful etcd Backup:

bash
Copy code
etcd backup saved successfully at /opt/etcd-snapshot-<timestamp>.db
Kubeadm Upgrade:

css
Copy code
Updating kubeadm to version 1.30.6-1.1...
Control Plane Node Upgrade:

mathematica
Copy code
Upgrading control plane node...
Control plane upgraded successfully.
Worker Node Drain and Uncordon:

Copy code
Draining node worker-node-1...
Uncordoning node worker-node-1...
Error Handling
If an etcd backup fails, the script will exit immediately to prevent potential data loss.
Ensure network connectivity to package repositories and verify permissions.
