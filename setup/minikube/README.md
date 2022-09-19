# k8s-tutorial
## Setup > minikube

 1. Follow step 1 of Installation [here](https://minikube.sigs.k8s.io/docs/start/) to get minikube installed. Do not run the `minikube start` command yet (you'll do that in the next step).

 1. Setup registry and add-ons in Minikube: 

    ```bash
    ~$ ./minikube-config.sh
    ``` 
 1. Test minikube:
    ```bash
    ~$ kubectl get namespaces

    NAME                   STATUS   AGE
    default                Active   77m
    kube-node-lease        Active   77m
    kube-public            Active   77m
    kube-system            Active   77m
    kubernetes-dashboard   Active   14m
    ```
** NOTE: You can run `minikube start` command (step 2 above) if you later lose your current-context in kubectl.

<!--```bash
    ~$ sudo snap refresh kubectl --channel=1.24/stable --classic

    ```-->