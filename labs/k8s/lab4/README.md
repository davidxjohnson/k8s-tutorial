# k8s-tutorial

## Labs > k8s > Lab4

### Explore Horizontal Pod Autoscaler using manifests

1. **A stack in one command** using a manifest.

    The manifest file [web-service.yaml](./web-service.yaml) can be used to automate the creation and deletion of a stack.

    ```bash
    ~$ kubectl create -f web-service.yaml --save-config

    deployment.apps/hello created
    service/hello created
    ```

    Although the manifest only contained a service and a deployment, the pods and replicaset are created because the deployment had a container template spec defined (with `replicas: 2`):
    
    ```bash
    ~$ kubectl get all

    NAME                    READY   STATUS    RESTARTS   AGE
    hello-5c9b6fdcf-6jhlq   1/1     Running   0          8s
    hello-5c9b6fdcf-jxgzw   1/1     Running   0          23m

    NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)        AGE
    service/hello        NodePort    10.107.172.22   <none>        80:32145/TCP   9m7s
    
    NAME                    READY   UP-TO-DATE   AVAILABLE   AGE
    deployment.apps/hello   1/1     1            1           9m7s

    NAME                              DESIRED   CURRENT   READY   AGE
    replicaset.apps/hello-5c9b6fdcf   1         1         1       9m7s
    ```

1. **Auto Scaling** your app.

    What if load exeeds the resource capacity of two pods? Can k8s automatically scale these resources without human intervention? The solution is a Horizontal Pod Autoscaler (HPA for short).

    An HPA can be created using the kubectl command (`kubectl autoscale deployment hello --cpu-percent=50 --min=1 --max=10`), but we are exploring manifests in this lab, so let's use a manifest instead:

    ```bash
    ~$ kubectl apply -f scaler.yaml

    horizontalpodautoscaler.autoscaling/hello created

    ~$ k get hpa hello

    NAME    REFERENCE          TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    hello   Deployment/hello   0%/50%    1         10        1          4m31s
    ```

    ** Note: Once you apply an HPA, the number of replicas indicated in your deployment will be under the control of the HPA.

1. **Load testing:**

    Let's add some load and see what happens:
    
    ```bash
    ~$ kubectl run load1 --image=busybox:latest --restart=Never \
    -- /bin/sh -c 'while sleep 0.01; do wget -q -O- http://hello; done'

    pod/load1 created

    ~$ kubectl get pods

    NAME                     READY   STATUS    RESTARTS   AGE
    hello-84c4b84859-79v5x   1/1     Running   0          15h
    load1                    1/1     Running   0          4s
    
    ~$ kubectl get hpa hello --watch # press Ctrl-C to exit

    NAME    REFERENCE          TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    hello   Deployment/hello   0%/50%    1         10        1          21m
    hello   Deployment/hello   90%/50%   1         10        1          21m
    hello   Deployment/hello   90%/50%   1         10        2          21m
    hello   Deployment/hello   85%/50%   1         10        2          23m
    hello   Deployment/hello   85%/50%   1         10        4          23m
    hello   Deployment/hello   45%/50%   1         10        4          24m
    ```

    Kill the load tester and watch the HPA scale back down:

    ```bash
    ~$ kubectl delete pod load1

    pod "load1" deleted

    ~$ kubectl get hpa hello --watch

    NAME    REFERENCE          TARGETS   MINPODS   MAXPODS   REPLICAS   AGE
    hello   Deployment/hello   51%/50%   1         10        4          33m
    hello   Deployment/hello   15%/50%   1         10        4          33m
    hello   Deployment/hello   15%/50%   1         10        2          33m
    hello   Deployment/hello   15%/50%   1         10        1          34m
    hello   Deployment/hello   0%/50%    1         10        1          34m
    ```

1. **Cleanup**:

    ```bash
    ~$ kubectl delete -f web-service.yaml,scaler.yaml

    deployment.apps "hello" deleted
    service "hello" deleted
    horizontalpodautoscaler.autoscaling "hello" deleted
    ```

---

**Further reference/learning:**

* Horizontal Pod Auto Scaler [Walkthrough](https://kubernetes.io/docs/tasks/run-application/horizontal-pod-autoscale-walkthrough/)

---

Next up: [Lab 5](/labs/k8s/lab5/README.md)
