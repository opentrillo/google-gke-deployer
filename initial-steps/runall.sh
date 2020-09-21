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


cd ./0-setup/ || exit
prdoer ./1-enable-services.sh
prdoer ./2-generate-key.sh
prdoer ./3-create-svc-account.sh
prdoer ./4-set-appserver.sh

cd ..

cd ./1-bucket/ && prdoer ./setup-bucket.sh && cd ..
cd ./2-mysql/ && prdoer ./create-mysql.sh && cd ..
cd ./3-edge/ && prdoer ./create-edge.sh && cd ..

cd ./4-gke/ || exit
prdoer ./1-create-cluster.sh
prdoer ./2-pre-deploy.sh
prdoer ./3-create-mp-config.sh
cd ..

prdoer ./generate-all-configs.sh
cat ./all-configs.txt


