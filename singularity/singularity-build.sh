#!/bin/bash

LOCAL_PATH="$(dirname $0)"
source "${LOCAL_PATH}/variables.sh"

sudo singularity build \
  --fix-perms \
  --sandbox \
  --force \
  $IMAGE_SANDBOX \
  $IMAGE_NAME.def

sudo singularity build \
  --fix-perms \
  --force \
  $IMAGE_CONTAINER.sif \
  $IMAGE_SANDBOX

