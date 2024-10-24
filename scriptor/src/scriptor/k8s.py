#!/usr/bin/env python3
# -*- coding=utf-8 -*-

"""
    Simple k8s (kubernetes) client.

    Created:  Dmitrii Gusev, 23.10.2024
    Modified:
"""

from loguru import logger
from kubernetes import client, config

# useful defaults
CONFIG_FILE = "c:/development/clusters_legacy_kube_config.json"

logger.info("Starting k8s client")

# Configs can be set in Configuration class directly or using helper utility
config.load_kube_config(CONFIG_FILE)

v1 = client.CoreV1Api()
print("Listing pods with their IPs:")
ret = v1.list_pod_for_all_namespaces(watch=False)
for i in ret.items:
    print("%s\t%s\t%s" % (i.status.pod_ip, i.metadata.namespace, i.metadata.name))
