export ZONE=us-central1-a
export NETWORK=default

PROJECT_ID=$(gcloud config get-value core/project 2> /dev/null)

export DEPLOYER_INSTANCE=trillo-preinstall-vm
export DEPLOYER_IMAGE=trillo-ent-deployer

echo "Creating deployer service account for the trillo platform"
SERVICE_ACCOUNT_ID=trillort-deployer

SA_EMAIL=$SERVICE_ACCOUNT_ID@$PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts create $SERVICE_ACCOUNT_ID --display-name "Trillo Platform Deployer"
gcloud projects add-iam-policy-binding $PROJECT_ID --member serviceAccount:$SA_EMAIL --role "roles/owner"

gcloud services enable compute.googleapis.com

gcloud beta compute --project=${PROJECT_ID} instances create ${DEPLOYER_INSTANCE} --zone=${ZONE} --machine-type=g1-small --network-tier=PREMIUM --maintenance-policy=MIGRATE --service-account=$SA_EMAIL --scopes=https://www.googleapis.com/auth/cloud-platform --image=${DEPLOYER_IMAGE} --image-project=project-trillort --boot-disk-size=100GB --boot-disk-type=pd-standard --boot-disk-device-name=trillo-gcs-edge --no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring --reservation-affinity=any --network=${NETWORK}

