delete pod <pod_name> -n <namespace> --grace-period 0 --force.


there are three file build.sh, schema.yaml and application.yaml which should have the same numbers.

---- build machine permission Issues (Only specific to gcp developer)

Issue :

$ docker version

Got this permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: Get http://%2Fvar%2Frun%2Fdocker.sock/v1.40/version: dial unix /var/run/docker.sock: connect: permission denied

Solution: as a non-root user run he below commands.

$ sudo groupadd docker
$ sudo usermod -aG docker $USER
$ newgrp docker

user cannot log in, then run this ....

gcloud auth --quiet configure-docker


