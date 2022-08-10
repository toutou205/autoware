#!/bin/bash

set -e

# Default settings
CUDA="on"
IMAGE_NAME="autoware/autoware"
TAG_PREFIX="local"
ROS_DISTRO="melodic"
BASE_ONLY="false"
VERSION=""

function usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "    -b,--base-only         Build the base image(s) only."
    echo "                           Default: $BASE_ONLY"
    echo "    -c,--cuda <on|off>     Enable Cuda support in the Docker."
    echo "                           Default: $CUDA"
    echo "    -h,--help              Display the usage and exit."
    echo "    -i,--image <name>      Set docker images name."
    echo "                           Default: $IMAGE_NAME"
    echo "    -r,--ros-distro <name> Set ROS distribution name."
    echo "                           Default: $ROS_DISTRO"
    echo "    -t,--tag-prefix <tag>  Tag prefix use for the docker images."
    echo "                           Default: $TAG_PREFIX"
    echo "    -v,--version <version> Build images for a specific version. Overrides tag-prefix."
    echo "                           Default: $VERSION"
}

OPTS=`getopt --options bc:hi:r:t:v: \
         --long base-only,cuda:,help,image-name:,ros-distro:,tag-prefix:,version: \
         --name "$0" -- "$@"`
eval set -- "$OPTS"

while true; do
  case $1 in
    -b|--base-only)
      BASE_ONLY="true"
      shift 1
      ;;
    -c|--cuda)
      param=$(echo $2 | tr '[:upper:]' '[:lower:]')
      case "${param}" in
        "on"|"off") CUDA="${param}" ;;
        *) echo "Invalid cuda option: $2"; exit 1 ;;
      esac
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    -i|--image-name)
      IMAGE_NAME="$2"
      shift 2
      ;;
    -r|--ros-distro)
      ROS_DISTRO="$2"
      shift 2
      ;;
    -t|--tag-prefix)
      TAG_PREFIX="$2"
      shift 2
      ;;
    -v|--version)
      VERSION="$2"
      shift 2
      ;;
    --)
      if [ ! -z $2 ];
      then
        echo "Invalid parameter: $2"
        exit 1
      fi
      break
      ;;
    *)
      echo "Invalid option"
      exit 1
      ;;
  esac
done

echo "Using options:"

if [ ! -z "$VERSION" ]; then
  echo -e "\tVersion: $VERSION"

  if [ "$VERSION" != "master" ]; then
    TAG_PREFIX=$VERSION
  fi
fi

echo -e "\tROS distro: $ROS_DISTRO"
echo -e "\tImage name: $IMAGE_NAME"
echo -e "\tTag prefix: $TAG_PREFIX"
echo -e "\tCuda support: $CUDA"
echo -e "\tBase only: $BASE_ONLY"

BASE=$IMAGE_NAME:$TAG_PREFIX-$ROS_DISTRO-base

# Update base image of Dockerfile.base so we don't use an outdated one
docker pull ros:$ROS_DISTRO

# Copy dependencies file into build context
cp ../dependencies .

docker build \
    --rm \
    --network=host \
    --tag $BASE \
    --build-arg ROS_DISTRO=$ROS_DISTRO \
    --file Dockerfile.base .

# Remove dependencies file from build context
rm dependencies

CUDA_SUFFIX=""
if [ $CUDA == "on" ]; then
    CUDA_SUFFIX="-cuda"
    docker build \
        --rm \
        --network=host \
        --tag $BASE$CUDA_SUFFIX \
        --build-arg FROM_ARG=$BASE \
        --file Dockerfile.cuda.$ROS_DISTRO .
fi

if [ "$BASE_ONLY" == "true" ]; then
    echo "Finished building the base image(s) only."
    exit 0
fi

DOCKERFILE="Dockerfile"

if [ -z "$VERSION" ]; then
  VERSION="master"
else
  if [[ $VERSION == 1.11.* ]]; then
    DOCKERFILE="$DOCKERFILE.legacy.colcon"
  elif [[ $VERSION == 1.10.* ]] ||
       [[ $VERSION == 1.9.*  ]] ||
       [[ $VERSION == 1.8.*  ]] ||
       [[ $VERSION == 1.7.*  ]] ||
       [[ $VERSION == 1.6.*  ]]; then
    DOCKERFILE="$DOCKERFILE.legacy.catkin"
  fi
fi

docker build \
    --rm \
    --network=host \
    --tag $IMAGE_NAME:$TAG_PREFIX-$ROS_DISTRO$CUDA_SUFFIX \
    --build-arg FROM_ARG=$BASE$CUDA_SUFFIX \
    --build-arg ROS_DISTRO=$ROS_DISTRO \
    --build-arg VERSION=$VERSION \
    --file $DOCKERFILE .
