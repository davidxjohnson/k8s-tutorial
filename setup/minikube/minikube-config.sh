#!/bin/bash
# git clone https://github.com/davidxjohnson/k8s-tutorial.git
minikube start --insecure-registry "10.0.0.0/24"
minikube addons enable registry
minikube addons enable metrics-server
minikube addons enable ingress
minikube addons list