# k8s-tutorial

## Labs > Docker > Lab2

### Building and running a docker image:

1. **Introducing the Dockerfile**

    The Dockerfile contains the basic instructions to build a Docker image. 

    For example:

    ```dockerfile
    FROM nginx:mainline-alpine
    EXPOSE 80/tcp
    RUN rm /etc/nginx/conf.d/*
    ADD hello.conf /etc/nginx/conf.d/
    ADD index.html /usr/share/nginx/html/
    ```

    In this example, we are sourcing an nginx proxy server `FROM` a remote repository in [DockerHub](https://hub.docker.com/_/nginx) and modifying it to behave as a web server. This is done by using an `ADD` verb in the Dockerfile that instructs Docker to load the local files into the new image. **Note: This example is a modified version that was sourced from GitHub [nginxinc/NGINX-Demos](https://github.com/nginxinc/NGINX-Demos/tree/master/nginx-hello).

2. **Build the image.** - notice the `Step 2/5` etc. that corresponds to the Dockerfile above.

    ```bash
    ~$ docker build . -t hello

    Sending build context to Docker daemon  13.31kB
    Step 1/5 : FROM nginx:mainline-alpine
    mainline-alpine: Pulling from library/nginx
    213ec9aee27d: Pull complete 
    2546ae67167b: Pull complete 
    23b845224e13: Extracting [=====================================>]     601B/601B
    23b845224e13: Pull complete 
    9bd5732789a3: Pull complete 
    328309e59ded: Pull complete 
    b231d02e5150: Pull complete 
    Digest: sha256:082f8c10bd47b6acc8ef15ae61ae45dd8fde0e9f389a8b5cb23c37408642bf5d
    Status: Downloaded newer image for nginx:mainline-alpine
    ---> 804f9cebfdc5
    Step 2/5 : EXPOSE 80/tcp
    ---> Running in 5e26f218d2c1
    Removing intermediate container 5e26f218d2c1
    ---> 37aeb4ecd242
    Step 3/5 : RUN rm /etc/nginx/conf.d/*
    ---> Running in b3bcc11b6e93
    Removing intermediate container b3bcc11b6e93
    ---> 51453f0ff33c
    Step 4/5 : ADD hello.conf /etc/nginx/conf.d/
    ---> c979b5482b4f
    Step 5/5 : ADD index.html /usr/share/nginx/html/
    ---> 0f1495e456f9
    Successfully built 0f1495e456f9
    Successfully tagged hello:latest
    ```

    We can see the new image in the local repository:

    ```bash
    ~$ docker images

    REPOSITORY                    TAG               IMAGE ID       CREATED              SIZE
    hello                         latest            0f1495e456f9   About a minute ago   23.6MB
    nginx                         mainline-alpine   804f9cebfdc5   4 weeks ago          23.5MB
    gcr.io/k8s-minikube/kicbase   v0.0.33           b7ab23e98277   6 weeks ago          1.14GB
    ```

1. **Run the new image.**

    ```bash
    ~$ docker run -d -p 8080:80 --rm --name goofy_cohen hello:latest

    508a8a5ff397dd49ef25d30d4809118f11965fadfbc11631b5eea73642ed83ca
    ```
    The container can be seen running:

    ```bash
    ~$ docker ps -n 1

    CONTAINER ID   IMAGE           COMMAND                  CREATED          STATUS          PORTS              NAMES
    3ea4b9010eb0   hello:latest    "/docker-entrypoint.…"   25 seconds ago   Up 25 seconds   0.0.0.0:8080->80   goofy_cohen
    ```

    Let's test the running container to see if it actually functions (Ctrl-C to exit).

    ```bash
    ~$ watch lynx --dump localhost:8080

    Every 2.0s: lynx --dump localhost:8080                                                                                                               dxj-vbox-server: Mon Sep 12 00:10:34 2022

    NGINX Logo
    Server address: 172.17.0.2:80
    Server name: 508a8a5ff397
    Date: 12/Sep/2022:00:10:34 +0000
    URI: /
    ```

    Let's cleanup:

    ```bash
    ~$ docker stop goofy_cohen

    goofy_cohen
    ```

**Further reference/learning:**

* Dockerfile [reference](https://docs.docker.com/engine/reference/builder/)

---

Next up: [Lab3](/labs/k8s/lab3/README.md)

