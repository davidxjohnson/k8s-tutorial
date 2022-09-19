# k8s-tutorial

## Labs > Docker > Lab1

### Getting aquainted with common Docker commands:

1. **pull** - retrieves images from remote sources and places them in the local repository.
    
    ```bash
    ~$ docker pull nginx:mainline-alpine

    mainline-alpine: Pulling from library/nginx
    7a6db449b51b: Downloading [=======>         ]  4.897MB/31.38MB
    ca1981974b58: Downloading [=========>       ]  4.963MB/25.35MB
    d4019c921e20: Download complete
    7cb804d746d4: Download complete
    e7a561826262: Download complete
    7247f6e5c182: Download complete
    ...
    ```
1. **images** - list images stored in the local repository.
    
    ```bash
    ~$ docker images

    REPOSITORY                    TAG               IMAGE ID       CREATED       SIZE
    nginx                         mainline-alpine   2b7d6430f78d   2 weeks ago   142MB
    gcr.io/k8s-minikube/kicbase   v0.0.33           b7ab23e98277   6 weeks ago   1.14GB
    ```
1. **run (detached)** - runs a local container (or downloads it to the local registry first before running it).

    ```bash
    ~$ docker run -d --name vibrant_einstein nginx:mainline-alpine

    fb08d9a6d8d8d612279b9cf8e9f2afd6cc7576cb571fb1d5dfa26b468fac8b0c
    ```

1. **ps** - will show running image containers.
   
    ```bash
    ~$ docker ps -n 1

    CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS          PORTS      NAME
    fb08d9a6d8d8   nginx:mainline-alpine   "/docker-entrypoint.…"   3 minutes ago    Up 3 minutes    80/tcp     vibrant_einstein
    ```

1. **logs** - show log output from image container. **NOTE:** Use the container name from the previous step to view logs.

    ```bash
    $ docker logs vibrant_einstein

    2022/09/11 20:38:56 [notice] 1#1: using the "epoll" event method
    2022/09/11 20:38:56 [notice] 1#1: nginx/1.23.1
    2022/09/11 20:38:56 [notice] 1#1: built by gcc 11.2.1 20220219 (Alpine 11.2.1_git20220219)
    2022/09/11 20:38:56 [notice] 1#1: OS: Linux 5.15.0-47-generic
    2022/09/11 20:38:56 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 1048576:1048576
    2022/09/11 20:38:56 [notice] 1#1: start worker processes
    2022/09/11 20:38:56 [notice] 1#1: start worker process 32
    2022/09/11 20:38:56 [notice] 1#1: start worker process 33
    ```

1. **exec** - most commonly used to execute a command in a running image container or shell into the container to troubleshoot problems. The following command will open an interactive terminal with a shell prompt. To exit, press Ctrl-D.

    ```bash
    ~$ docker exec -it vibrant_einstein /bin/sh

    / ls -lah
    total 80K    
    drwxr-xr-x    1 root     root        4.0K Sep 11 20:38 .
    drwxr-xr-x    1 root     root        4.0K Sep 11 20:38 ..
    -rwxr-xr-x    1 root     root           0 Sep 11 20:38 .dockerenv
    drwxr-xr-x    2 root     root        4.0K Aug  9 08:47 bin
    drwxr-xr-x    5 root     root         340 Sep 11 20:38 dev
    drwxr-xr-x    1 root     root        4.0K Aug  9 20:58 docker-entrypoint.d
    -rwxrwxr-x    1 root     root        1.2K Aug  9 20:58 docker-entrypoint.sh
    ```

1. **stop** - terminates a running container. 

    ```bash
    ~$ docker stop vibrant_einstein

    vibrant_einstein
    ```

    A `docker ps -n 1` command will verify that the container terminated. Note that the status of the container is `Exited`. 

    ```bash
    $ docker ps -n 1
    CONTAINER ID   IMAGE                   COMMAND                  CREATED          STATUS                     NAMES
    fb08d9a6d8d8   nginx:mainline-alpine   "/docker-entrypoint.…"   41 minutes ago   Exited (0) 2 minutes ago   vibrant_einstein
    ```

1. **rm** - delete a non-running image container.
    
    ```bash
    ~$ docker rm vibrant_einstein

    vibrant_einstein
    ```

    The `rm` command can be used to cleanup old container runs that are clutering up your disk.

    ```bash
    ~$ docker ps --all

    CONTAINER ID   IMAGE                   COMMAND                  CREATED             STATUS
    8ff18cfd63d4   nginx:mainline-alpine   "/docker-entrypoint.…"   49 minutes ago      Exited (2) 49 minutes ago
    89f9840b5936   nginx:mainline-alpine   "/docker-entrypoint.…"   55 minutes ago      Exited (0) 55 minutes ago

    ~$ docker rm 8ff18cfd63d4 89f9840b5936

    8ff18cfd63d4
    89f9840b5936
    ```

1. **rmi** - used to remove an image from the local respository.

    ```bash
    ~$ docker images
    
    REPOSITORY                    TAG               IMAGE ID       CREATED       SIZE
    nginx                         mainline-alpine   804f9cebfdc5   4 weeks ago   23.5MB
    gcr.io/k8s-minikube/kicbase   v0.0.33           b7ab23e98277   6 weeks ago   1.14GB

    ~$ docker rmi nginx:mainline-alpine

    Untagged: nginx:mainline-alpine
    Untagged: nginx@sha256:082f8c10bd47b6acc8ef15ae61ae45dd8fde0e9f389a8b5cb23c37408642bf5d
    Deleted: sha256:804f9cebfdc58964d6b25527e53802a3527a9ee880e082dc5b19a3d5466c43b7
    Deleted: sha256:bd096861e89a30cb348f70e018a3a79dd98cb4e7fecc5c5f5452992446338923
    Deleted: sha256:0f5b9e6d2cd4178f00e7877608da01445216c05b1e599cee52ff6cc733c80c09
    Deleted: sha256:4064741cd422895de2f6458f4ec47810fe762d488a3064a9c9bfd36a0a7559f9
    Deleted: sha256:5ba70ded614c06d3792512671b3eac4c7af91594a169a8673461c38452f22059
    Deleted: sha256:c3cb61deaecfc83beb4bc37d56eb6e3d24662947cdac0dc722648de0e838849c
    Deleted: sha256:994393dc58e7931862558d06e46aa2bb17487044f670f310dffe1d24e4d1eec7
    ```
---

**Further reference/learning:**

* Using the [Docker command line](https://docs.docker.com/engine/reference/commandline/cli/)

---

Next up: [Lab 2](/labs/docker/lab2/README.md).