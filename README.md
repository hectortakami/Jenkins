# Docker + Jenkins CI/CD

## Dockerized Jenkins (Ubuntu 20.04)

### Docker Installation

- **docker**

  1. Install `docker` command & library
     - Ubuntu Linux: https://docs.docker.com/engine/install/ubuntu/
  2. Enable all users to run docker command `sudo usermod -aG docker [username]`
  3. Give permissions to the docker command `sudo chmod 666 /var/run/docker.sock`
  4. Test the installation `docker --version`

- **docker-compose**
  1. Install `docker-compose` command & library
     - Ubuntu Linux: https://docs.docker.com/engine/install/ubuntu/
  2. Apply executable permissions to the command `sudo chmod +x /usr/local/bin/docker-compose`
  3. Test the installation `docker-compose version`

### Jenkins Installation

1. Clone the Jenkins image using Docker

   ```
   $ docker pull jenkins/jenkins
   ```

2. Verify the image download

   ```
   $ docker images

   REPOSITORY        TAG       IMAGE ID       CREATED      SIZE
   jenkins/jenkins   latest    30501cbe55ca   0 days ago   573MB
   ```

3. Create the container directories & `docker-compose.yml` file

   ```
   $ mkdir -p Jenkins/jenkins_home
   $ chown 1000 jenkins

   $ touch Jenkins/jenkins_home/docker-compose.yml
   ```

   **docker-compose.yml**

   ```yaml
   version: '3'
   services:
     jenkins:
       image: jenkins/docker
       build:
         context: ./
       ports:
         - 8080:8080
         - 50000:50000
       container_name: jenkins
       volumes:
         - $PWD/jenkins_home:/var/jenkins_home
         - /var/run/docker.sock:/var/run/docker.sock
   networks:
     net:
   ```

4. Create a `Dockerfile` with the following commands

   ```
   $ cd jenkins
   $ touch Dockerfile
   ```

   **Dockerfile**

   ```dockerfile
   FROM jenkins/jenkins
   USER root

   RUN apt-get update && \
   apt-get -y install apt-transport-https \
        ca-certificates \
        curl \
        gnupg2 \
        software-properties-common && \
   curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
   add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce


   RUN curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose

   RUN usermod -aG docker jenkins

   USER jenkins
   ```

5. Enable container

   ```
   $ cd jenkins
   $ docker-compose up -d

   $ docker ps

   CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                              NAMES
   container_id   jenkins/docker   "/sbin/tini -- /usr/…"   0 minutes ago   Up 0 minutes   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkins
   ```

   **Note: The container must be build without problems, otherwise review the `Dockerfile`. Reference: https://github.com/macloujulian/dockerjenkins/blob/master/Dockerfile**

6. Retreive `initalAdminPassword`

   ```
   $ cat jenkins/jenkins_home/secrets/initialAdminPassword
   ```

   _Note: Copy the output for the next step_

7. Startup configuration of the Jenkins Engine

   1. Navigate to **http://localhost:8080**
   2. Paste the `initalAdminPassword` from previous step to grant access.
   3. Click on "Install suggested plugins" and continue the installation.
   4. Create an username/password to login the configured engine.
   5. (Optional) you can change the default route of **http://localhost:8080** to another significant URL.

**By now the Jenkins Engine must be up & running in a Docker container**

8. Enter the container bash as root to give jenkins user docker privileges

```
$ docker exec -ti --user root jenkins bash
$ chown jenkins /var/run/docker.sock
$ exit
```

9. Verify jenkins bash capabilities to execute docker

```
$ docker exec -ti jenkins bash
$ docker ps
```

**The installation is now complete! :D**

# Notes

## Commands

**Check for running containers**

```
$ docker ps
```

**Start container**

```
$ cd jenkins
$ docker-compose up -d
$ docker-compose start
```

**Stop (and remove) container**

```
$ cd jenkins
$ docker-compose stop
$ docker-compose down
```

**Copy a script into the jenkins container (to run as a job)**

```
$ chmod +x (filename.sh)
$ docker cp (filename.sh) jenkins/:opt
```

**Enter into the Command (BASH) of the container**

```
$ cd jenkins
$ docker exec -ti jenkins bash
```

**Display logs**

```
$ cd jenkins
$ docker-compose logs -f
```

**Remove all containers & images**

```
$ docker rm $(docker ps -a -q)
$ docker rmi $(docker images -q)
```

**Re-build container (run always the `Dockerfile` is modified)**

```
$ docker-compose stop
$ docker-compose build
$ docker-compose up -d
```

## SSH Kali (optional)

```
$ sudo nmap -sn _gateway/24
$ sudo systemctl start ssh.socket
$ sudo systemctl enable ssh.socket
$ systemctl status ssh.socket
```
