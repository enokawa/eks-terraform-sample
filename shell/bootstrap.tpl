#!/bin/bash
set -o xtrace
/etc/eks/bootstrap.sh ${eks_cluster_name}
