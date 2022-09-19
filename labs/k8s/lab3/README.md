# k8s-tutorial

## Labs > k8s > Lab3

### Build and run a Docker image on k8s.

1. **About registries:**

    In the Docker labs, we learned about the local registry and a remote registry. The remote registries are often public repositories the we `PULL` from and store in our local repository. This is how Docker works. As it turns out, k8s uses docker and thus it also has a local repository. In a multi-node k8s cluster, each node has its own instance of Docker and therefore its own local repo.

    To make the labs easy, we will use the Minikube local repository instead of our own. This means taht all our Docker commands will operate against the Minikube local repository. 
    
    Here is how we do that:

    ```bash
    ~$ minikube start
    
    ~$ minikube docker-env

    export DOCKER_TLS_VERIFY="1"
    export DOCKER_HOST="tcp://192.168.49.2:2376"
    export DOCKER_CERT_PATH="/home/dxj/.minikube/certs"
    export MINIKUBE_ACTIVE_DOCKERD="minikube"

    # To point your shell to minikube's docker-daemon, run:
    # eval $(minikube -p minikube docker-env)
    ```
    
    So, as the message reads, we simply run the `eval` command thus:

    ```bash
    ~$ eval $(minikube -p minikube docker-env)
    ```

    We can now see the content of Minikube's local repository thus:

    ```bash
    ~$ docker images

    REPOSITORY                                TAG       IMAGE ID       CREATED         SIZE
    k8s.gcr.io/kube-apiserver                 v1.24.3   d521dd763e2e   2 months ago    130MB
    k8s.gcr.io/kube-proxy                     v1.24.3   2ae1ba6417cb   2 months ago    110MB
    k8s.gcr.io/kube-controller-manager        v1.24.3   586c112956df   2 months ago    119MB
    k8s.gcr.io/kube-scheduler                 v1.24.3   3a5aa3a515f5   2 months ago    51MB
    kubernetesui/dashboard                    <none>    1042d9e0d8fc   3 months ago    246MB
    kubernetesui/metrics-scraper              <none>    115053965e86   3 months ago    43.8MB
    k8s.gcr.io/etcd                           3.5.3-0   aebe758cef4c   5 months ago    299MB
    k8s.gcr.io/pause                          3.7       221177c6082a   6 months ago    711kB
    k8s.gcr.io/coredns/coredns                v1.8.6    a4ca41631cc7   11 months ago   46.8MB
    k8s.gcr.io/pause                          3.6       6270bb605e12   12 months ago   683kB
    gcr.io/k8s-minikube/storage-provisioner   v5        6e38f40d628d   17 months ago   31.5MB
    ```

    Let's build an image container using our Dockerfile again:
    ```bash
    ~$ docker build . -t hello

    Sending build context to Docker daemon  14.34kB
    Step 1/5 : FROM nginx:mainline-alpine
    ---> 804f9cebfdc5
    Step 2/5 : EXPOSE 80/tcp
    ---> Running in 7f956e9737a9
    Removing intermediate container 7f956e9737a9
    ---> 4ecff99e95d7
    Step 3/5 : RUN rm /etc/nginx/conf.d/*
    ---> Running in 2e854f71b1ea
    Removing intermediate container 2e854f71b1ea
    ---> 4f11e79dc87b
    Step 4/5 : ADD hello.conf /etc/nginx/conf.d/
    ---> bdedd5b65f61
    Step 5/5 : ADD index.html /usr/share/nginx/html/
    ---> fbc4abc95cea
    Successfully built fbc4abc95cea
    Successfully tagged hello:latest
    ```

    We can see the image in the Minikube local registry:

    ```bash
    ~$ docker images
    REPOSITORY     TAG          IMAGE ID       CREATED         SIZE
    hello          latest       fbc4abc95cea   2 minutes ago   23.6MB
    ...
    ```
1. **Deploy to k8s:** (and deal with a minor Minikube glitch):

    ```bash
    $ kubectl create deployment hello --image hello

    deployment.apps/hello created
    
    # a workaround for the fact that we didn't publish to an external image repository.
    ~$ kubectl patch deployment hello -p \
    '{"spec":{"template":{"spec":{"containers":[{"name":"hello","imagePullPolicy":"Never"}]}}}}'

    deployment.apps/hello patched
    
    ~$ kubectl get deployment hello

    NAME    READY   UP-TO-DATE   AVAILABLE   AGE
    hello   1/1     1            1           3m40s

    ~$ kubectl get pods

    NAME                    READY   STATUS    RESTARTS   AGE
    hello-5c9b6fdcf-q8tjv   1/1     Running   0          4m36s
    ```

    So we see our container running and ready, but now it needs to be exposed:

    ```bash
    ~$ kubectl expose deployment hello --port 80 --type NodePort

    service/hello exposed
    
    ~$ kubectl get service hello

    NAME    TYPE       CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
    hello   NodePort   10.102.107.123   <none>        80:32200/TCP   2s

    ~$ minikube service url hello

    |-----------|-------|-------------|---------------------------|
    | NAMESPACE | NAME  | TARGET PORT |            URL            |
    |-----------|-------|-------------|---------------------------|
    | default   | hello |          80 | http://192.168.49.2:32200 |
    |-----------|-------|-------------|---------------------------|
    * Opening service default/hello in default browser...
      http://192.168.49.2:32200
    ```

    Let's test it (be sure to use url in your console above, press Ctrl-C to exit):

    ```bash
    ~$ watch -n0 lynx --dump http://192.168.49.2:32200

    NGINX Logo
    Server address: 172.17.0.5:80
    Server name: hello-5c9b6fdcf-q8tjv
    Date: 12/Sep/2022:03:16:37 +0000
    URI: /
                Request ID: 85195653b8bcc8218d38cab3f6a9aa9c
                             © NGINX, Inc. 2018
    ```

    ** Note that the `Request Id` changes every 2 seconds. The pod (Docker image) is working.

    Let's cleanup:

    ```bash
    ~$ kubectl delete service hello
    ~$ kubectl delete deployment hello
    ```

---
**Further reference/learning:**

* Minikube [basic controls](https://minikube.sigs.k8s.io/docs/handbook/controls/)
* kubectl [command reference](https://kubernetes.io/docs/reference/generated/kubectl/kubectl-commands)
* Using kubectl to [create a deployment](https://kubernetes.io/docs/tutorials/kubernetes-basics/deploy-app/deploy-intro/)
* Using a service to [expose your app](https://kubernetes.io/docs/tutorials/kubernetes-basics/expose/expose-intro/)
* Service [concepts](https://kubernetes.io/docs/concepts/services-networking/service/)

---

Next up: [Lab 4](/labs/k8s/lab4/README.md)