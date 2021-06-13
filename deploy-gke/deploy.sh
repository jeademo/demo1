#!/usr/bin/env bash

# Fail fast and be aware of exit codes
set -ef -o pipefail

# Activate trace if needed
[ "$TRACE" = "true" ] && set -x

# Use proper credentials according to environment
GKE=`grep GKE GCP.info | cut -f2 -d:`
REGION=`grep REGION GCP.info | cut -f2 -d:`
PROJECT=`grep PROJECT GCP.info | cut -f2 -d:`

VERSION=$1

#export GOOGLE_APPLICATION_CREDENTIALS=${GOOGLE_CRED}
#export GOOGLE_CLOUD_KEYFILE_JSON=${GOOGLE_CRED}

sed -i "s/APP/${IMAGE_NAME}/g; s/VERSION/${VERSION}/g" app.yaml

gcloud auth activate-service-account --key-file=${GOOGLE_CRED}
gcloud container clusters get-credentials ${GKE} --region ${REGION} --project ${PROJECT}

cat app.yaml
#kubectl apply -f app.yaml