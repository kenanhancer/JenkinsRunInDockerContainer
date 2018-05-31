docker build . -t JenkinsRunInDocker

docker run --privileged -u root -v /var/run/docker.sock:/var/run/docker.sock -v $(which docker):/bin/docker -p 8080:8080 -p 50000:50000 JenkinsRunInDocker