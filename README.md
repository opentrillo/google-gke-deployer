# Overview

This repository contains the GCP Marketplace deployment resources to launch Trillo Platform on Google Container Engine (GKE). 

# Getting Started

## Tool dependencies

- [gcloud](https://cloud.google.com/sdk/)
- [docker](https://docs.docker.com/install/)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/). You can install
  this tool as part of `gcloud`.
- [jq](https://github.com/stedolan/jq/wiki/Installation)
- [make](https://www.gnu.org/software/make/)
- [watch command](https://en.wikipedia.org/wiki/Watch_(Unix))

## Set Your GCP Config and Authenticate

```shell
gcloud config set project <GCP Project>
gcloud config set compute/zone <zone>
gcloud config set account <user>
gcloud auth login
```
## Google Container Registry (GCR)

Make files are set up to use Google Container Registry (GCR). Ensure that you GCR enabled for your project. 

[Enable the GCR API](https://console.cloud.google.com/apis/library/containerregistry.googleapis.com)

## Building the Deployer Image
Build from the [Dockerfile](https://github.com/opentrillo/google-gke-deployer/blob/master/Dockerfile).

```shell
docker build -t deployer:latest .

docker tag deployer:latest gcr.io/<path>/deployer:<tag>

docker push gcr.io/<path>/deployer:<tag>
```

## Create Your Cluster

See
[Getting Started](https://github.com/GoogleCloudPlatform/marketplace-k8s-app-tools/blob/master/README.md#getting-started)
to create your cluster. Trillo Platform requires a minimum 3 node
cluster with each node having a minimum of 2 vCPU and k8s version 1.8.

Then:

```shell    
gcloud container clusters get-credentials <cluster> 
```

## Installing Trillo Platform on Your Cluster

### Create your Namespace
```shell
kubectl create namespace <namespace>
export NAMESPACE=<namespace>
```

### One-time CRD Setup

```shell
make crd/install
```

### Install Trillo Platform on your Cluster

```shell
make app/install
```

### Monitor the Installation

```shell
make app/watch
```

### Monitor the Trillo Platform Pods

```shell
kubectl get pods --namespace=<namespace>
```

### Setup Wizard
Get the Trillo Platform Runtime URL:

```shell
kubectl get ing -n <namespace> | grep trillo-rt

ex. kubectl get ing -n deployer-test | grep trillo-rt
```
Paste the domain name listed into your browser to go to the Trillo Platform Operations Center and start the setup process. Or you can click on the cjoc Endpoints link under Kubernetes Engine > Services in the GCP console.


## Using Trillo Platform

### Getting Started Guide
To get started using Trillo Platform, watch our YouTube Channel [Getting Started Videos](https://www.youtube.com/channel/UCI9jb0O52kSp7949nfPvTbA).

## DNS
The installation configures an trillo.io domain (customizable).

## HTTPS
The installation configures a self-signed certificate. You may also configure your own SSL certificate.

## Additional Resources
* [Online Documentation](https://trillo.atlassian.net/wiki/spaces/DOC/overview)

* [Platform Architecture](https://www.trillo.io/WebSite/Platform)

* [Solution Brief](https://drive.google.com/a/trillo.io/file/d/12Z3QabqdifgHp8XBM0U1S6MpAv3HUNPM/view?usp=sharing)

## Licensing
Request a license by sending an email to info@trillo.io or support@trillo.io.
 
## Trillo.io Support
For Trillo.io support, [visit the support page](https://www.trillo.io/WebSite/Support).

## Delete the Installation (optional)

```shell
make app/uninstall
```
or

```shell
kubectl delete application <application> -n <namespace>
```

