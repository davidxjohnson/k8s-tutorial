# k8s-tutorial

## Labs > k8s > Lab5

### Explore Ingress Control using manifests

1. **Verify Ingress Control** from [setup](/setup/minikube/README.md).

    ```bash
    ~$ kubectl get pod,service -o name -n ingress-nginx\
        -l app.kubernetes.io/name=ingress-nginx  

    pod/ingress-nginx-admission-create-dfptj
    pod/ingress-nginx-admission-patch-qjc7k
    pod/ingress-nginx-controller-755dfbfc65-kcjnn
    service/ingress-nginx-controller
    service/ingress-nginx-controller-admission
    ```

1. **Setup blue/green services**

    ```bash
    ~$ kubectl create -f blue-service.yaml,green-service.yaml

    deployment.apps/blue created
    service/blue created
    deployment.apps/green created
    service/green created

    ~$ kubectl get all

    NAME                         READY   STATUS    RESTARTS   AGE
    pod/blue-7bc44dc79f-8gzvz    1/1     Running   0          77s
    pod/blue-7bc44dc79f-k8qht    1/1     Running   0          77s
    pod/green-78b776c949-b4x4b   1/1     Running   0          77s
    pod/green-78b776c949-n2ttv   1/1     Running   0          77s

    NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
    service/blue         ClusterIP   10.106.30.24   <none>        80/TCP    77s
    service/green        ClusterIP   10.97.123.9    <none>        80/TCP    77s
    
    NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/blue    2/2     2            2           78s
    deployment.apps/green   2/2     2            2           77s

    NAME                               DESIRED   CURRENT   READY   AGE
    replicaset.apps/blue-7bc44dc79f    2         2         2       77s
    replicaset.apps/green-78b776c949   2         2         2       77s
    ```

1. **Setup Ingress Rules** for the blue/green services

    **Note: The service types of blue/green are `ClusterIP` whereas the `hello` service we created in [lab3](/labs/k8s/lab3/README.md) was `--type NodePort`. The type ClusterIP is accessible internal to k8s, whereas type NodePort is accessible outside of k8s. The ingress controller is type NodePort and therefore externally accessible. 
    
    ![What Is Ingress?](./ingress.svg)

    What we need to do next is create some routing rules.

    ```bash
    ~$ kubectl create -f routing.yaml

    ingress.networking.k8s.io/blue created
    ingress.networking.k8s.io/green created

    ~$ kubectl get ingress

    NAME    CLASS   HOSTS   ADDRESS        PORTS   AGE
    blue    nginx   *       192.168.49.2   80      5m42s
    green   nginx   *       192.168.49.2   80      5m42s
    ```

1. **Verify Ingress** rules and routes

    ```bash
    # get the external ip and port of the ingress controller
    ~$ minikube service ingress-nginx-controller url -n ingress-nginx

    |---------------|--------------------------|-------------|---------------------------|
    |   NAMESPACE   |           NAME           | TARGET PORT |            URL            |
    |---------------|--------------------------|-------------|---------------------------|
    | ingress-nginx | ingress-nginx-controller | http/80     | http://192.168.49.2:32176 |
    |               |                          | https/443   | http://192.168.49.2:32518 |
    |---------------|--------------------------|-------------|---------------------------|
    [ingress-nginx ingress-nginx-controller http/80
    http/443 http://192.168.49.2:32176 #<- ingress controller URL you want
    https://192.168.49.2:32518]
    ```

    Let's test the routes: (Press Ctrl-C to exit)

    ```bash
    ~$ watch -n0 lynx --dump http://192.168.49.2:32176/blue
    ~$ watch -n0 lynx --dump http://192.168.49.2:32176/green
    ```

1. **Cleanup**

    ```bash
    ~$ kubectl delete \
        -f blue-service.yaml,green-service.yaml,routing.yaml
    
    deployment.apps "blue" deleted
    service "blue" deleted
    deployment.apps "green" deleted
    service "green" deleted
    ingress.networking.k8s.io "blue" deleted
    ingress.networking.k8s.io "green" deleted
    ```

---

**Further reference/learning:**

* Setup Ingress in [Minikube](https://kubernetes.io/docs/tasks/access-application-cluster/ingress-minikube/)
* Ingress [concepts](https://kubernetes.io/docs/concepts/services-networking/ingress/)
