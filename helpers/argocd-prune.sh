#!/bin/bash
namespace="argocd"
appname="argocd-image-updater"
kubectl api-resources --verbs=list --namespaced -o name \
  | xargs -n 1 kubectl get --show-kind --ignore-not-found -n $namespace -l argocd.argoproj.io/instance=$appname -o name \
  | xargs -n 1 kubectl delete -n $namespace
