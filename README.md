# Jenkins CI/CD

Dependencies 

- docker
- docker-compose

## Configure Docker + Jenkins

### Clone the Jenkins image using Docker
```
$ docker pull jenkins/jenkins
```

### Verify the image download
```
$ docker images

REPOSITORY        TAG       IMAGE ID       CREATED      SIZE
jenkins/jenkins   latest    30501cbe55ca   0 days ago   573MB
```

### Create the container directories & `docker-compose.yml` file

```
$ mkdir -p jenkins/jenkins_home
$ chown 1000 jenkins

$ touch jenkins/jenkins_home/docker-compose.yml
```

**docker-compose.yml**
```yaml
version: '3'
services:
    jenkins: 
        image: jenkins/jenkins
        ports: 
            - 8080:8080
            - 50000:50000
        container_name: jenkins
        volumes: 
            - $PWD/jenkins_home:/var/jenkins_home
networks:
    net:
```

### Enable Docker container
```
$ cd jenkins
$ docker-compose up -d

$ docker ps

CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                              NAMES
container_id   jenkins/jenkins   "/sbin/tini -- /usr/…"   30 minutes ago   Up 30 minutes   0.0.0.0:8080->8080/tcp, 0.0.0.0:50000->50000/tcp   jenkins
```

### Retreive `initalAdminPassword`
```
$ cat jenkins/jenkins_home/secrets/initialAdminPassword
```
_Note: Copy the output for the next step_


### Startup configuration of the Jenkins Engine

1. Navigate to **http://localhost:8080**
2. Paste the `initalAdminPassword` from previous step to grant access.
3. Click on "Install suggested plugins" and continue the installation.
4. Create an username/password to login the configured engine.
5. (Optional) you can change the default route of **http://localhost:8080** to another significant URL.

**By now the Jenkins Engine must be up & running in a Docker container**


## Docker Commands

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