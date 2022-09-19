# k8s-tutorial
## Setup > Docker

**IMPORTANT:** If your host is Windows, **install the following on the vbox guest** rather than on the Windows host.

---

Follow [these instructions](https://docs.docker.com/engine/install/) to install Docker Engine (if on MAC OS, you might try Docker Desktop).


To verify the install, check that the dockerd daemon is running:

```bash
~$ ps -ef | grep dockerd

root         920       1  0 13:09 ?        00:00:00 /usr/bin/dockerd -H fd:// --containerd=/run/containerd/containerd.sock
```

Can you run a container? 

```bash
~$ docker run hello-world

Unable to find image 'hello-world:latest' locally
latest: Pulling from library/hello-world
2db29710123e: Pull complete
Digest: sha256:7d246653d0511db2a6b2e0436cfd0e52ac8c066000264b3ce63331ac66dca625
Status: Downloaded newer image for hello-world:latest

Hello from Docker!
```

If you encounter a security related error, you likely need to make some adjustments to run docker commands as a non-root user.

```bash
~$ sudo groupadd docker
~$ sudo usermod -aG docker $USER
~$ newgrp - docker
```

If you still can't run hellow-world, close your terminal session and open a new one, then try again.


Official docs are [here](https://docs.docker.com/engine/install/linux-postinstall/) if you need to troubleshoot further.