#!/usr/bin/env bash

## make sure you are running with a temporary service token that has super privileges to install the software.

function prdo {
	echo " -> $ $@"
	$@
}

#
# Print the given command, execute it
#	and exit if error happened
function prdoer {
	prdo $@
	if [ $? -ne 0 ]; then
		echo " [!] Failed!"
		exit 1
	fi
}

# License check
LICENSE_FILE=./4-gke/license.yaml
if [[ -s "$LICENSE_FILE" ]]; then
  echo "License file is present"
else
  echo "License file does not exist. Please download from the marketplace and copy it under " $LICENSE_FILE
fi

cd ./0-setup/ || exit
prdoer ./0-install-tools.sh
prdoer ./1-enable-services.sh
prdoer ./2-generate-key.sh
prdoer ./3-create-svc-account.sh
prdoer ./5-set-latest-versions.sh
prdoer ./7-create-docai-processors.sh

cd ..

cd ./1-bucket/ && prdoer ./setup-bucket.sh && cd ..
cd ./2-mysql/ && prdoer ./create-mysql.sh && cd ..
cd ./2b-redis/ && prdoer ./create-redis.sh && cd ..
cd ./3-edge/ && prdoer ./create-edge.sh && cd ..

#for Custom domains it is better to comment following lines until <dig custom-domains> outputs are available.
cd ./4-gke/ || exit
prdoer ./1-create-cluster.sh
prdoer ./2-pre-deploy.sh
prdoer ./3-setup-helm.sh
prdoer ./helmrt.sh
prdoer ./helmui.sh
cd ..

prdoer ./generate-all-configs.sh
cat ./all-configs.txt


