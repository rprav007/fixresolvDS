## Problem Statement

-> Due to a CoreOS bug [More on the AWS side, Amazon uses domain to create the search path instead of allowing customization of it] we are unable to have more than one search domain in resolv.conf. So, we either can adf.examplecom so you can exec to pods and view logs, or we can have the example.com search domain so you can resolve short hostnames (access nodes outside of the adf domain)

-> Re-Configure kubelet to use custom resolv.conf instead of node's resolv.conf 
{--volume=resolv,kind=host,source=/etc/kubernetes/resolv.conf instead of /etc/resolv.conf}

## Daemon Set to append required domain in the search string

This daemon set when deployed will append the required search string to resolv.conf

  -> Creates a separate name space 
  -> Creates a service account in the namespace
  -> Create role binding for the service account with appropriate priveleges in the namespace
  -> Create DS

It will also update the kubelet service to point to the new resolv.conf and schedule for a reboot

In order for the pods to pick up the changes, nodes require a reboot, which is automatic as the annotation is set on the node for the container linux update operator to cycle through and act on it

## How to deploy DS

-> Clone git repo

-> set kubeconfig to the appropriate cluster

-> cd fixresolveDS

-> kubectl create -f k8s/


