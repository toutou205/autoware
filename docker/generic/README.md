# Autoware Docker

Docker can be used to allow developers to quickly get a development environment
ready to try and develop Autoware.

There are two sets of Docker images for Autoware:
* **Base image** - Provides a development container with all the dependencies to
build and run Autoware. When starting a container using this image, the Autoware
source code is mounted as a volume allowing users to develop and build Autoware.
Base images have the label *-base* in their names.

* **Pre-built Autoware** - Provides a container with a copy of Autoware
pre-built. This image is built on top of the base image.

Each set of Docker images comes with and without Cuda support. Images with Cuda
support have the label *-cuda* in their names.

This set of Dockerfiles can be used to build and run containers natively on both
AArch64 and x86_64 systems.

## Requirements

* Recent version of [Docker CE](https://docs.docker.com/install/linux/docker-ce/ubuntu/)
* [NVIDIA Docker v2](https://github.com/NVIDIA/nvidia-docker) if your system
has Cuda support

## How to build

To build the docker image(s), use the **build.sh** script. For details on the
parameters available, try:
```
$ ./build.sh --help
```

## How to run

To start a container use the **run.sh** tool. Which container will start
depends on the parameters passed to **run.sh**.

### Examples of usage:

```
$ ./run.sh
```
Will start a container with pre-built Autoware and CUDA support enabled. This
image is useful for people trying out Autoware without having to install any
dependencies or build the project themselves. Default image:
_autoware/autoware:latest-melodic-cuda_

```
$ ./run.sh --ros-distro kinetic
```
Same as above, but with ROS Kinetic and Ubuntu 16.04. Default image:
_autoware/autoware:latest-kinetic-cuda_

```
$ ./run.sh --base-only <autoware_home>
```
Will start a container with the base image (without pre-built Autoware). The
container will have CUDA enabled and the Autoware code base at path `<autoware_home>`
will be mounted as a volume on the container under _/home/autoware/Autoware_.
This is the suggested image for developers using Docker as their development
environment. Default docker image:
_autoware/autoware:latest-melodic-base-cuda_

```
$ ./run.sh --ros-distro kinetic --base-only <autoware_home>
```
Same as above but with ROS Kinetic and Ubuntu 16.04. Default image:
_autoware/autoware:latest-kinetic-base-cuda_

```
$ ./run.sh --base-only <autoware_home> --cuda off
```
Same as previous example, but CUDA support is disabled. This is useful if you
are running on a machine without CUDA support. Note that packages that require
CUDA will not be built or will execute on CPU. Default image:
_autoware/autoware:latest-melodic-base_

```
$ ./run.sh --ros-distro kinetic --base-only <autoware_home> --cuda off
```
Same as above but with ROS Kinetic and Ubuntu 16.04. Default image:
_autoware/autoware:latest-kinetic-base_

```
./run.sh --tag-prefix local --base-only <autoware_home>
```
Will start a container with the tag prefix _local_. Note that _local_ is the
default tag prefix when using the **build.sh** tool. Image name:
_autoware/autoware:local-melodic-base-cuda_

```
./run.sh --ros-distro melodic --tag-prefix local --base-only <autoware_home>
```
Same as above but with ROS Melodic and Ubuntu 18.04. Image name:
_autoware/autoware:local-melodic-base-cuda_

For details on all parameters available and their default value, try:
```
$ ./run.sh --help
```

## Notes

* The default values for the **--image** and **--tag-prefix**
parameters in build.sh and run.sh are different. This is because run.sh defaults
to values used to retrieve images from Docker Hub. When running containers from
images you have built, make sure the parameters mentioned match.

* Containers started with the **run.sh** tool are automatically removed upon
exiting the container. Make sure you use the _shared_dir_ to save any data you
want to preserve.

* `run.sh` can be called with the `--skip-uid-fix` flag to disable automatic fixing
of uid and directory permissions in the container. Using this flag will reduce the
initialization time if the host user does not match the default user ID in the Docker
image but the `shared_dir` volume will not be accessible.
