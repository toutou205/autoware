set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_VERSION 1)
set(CMAKE_SYSTEM_PROCESSOR aarch64)
set(CMAKE_CROSSCOMPILING ON)
set(CMAKE_SYSROOT $ENV{AUTOWARE_SYSROOT})
set(ROS_DISTRO $ENV{ROS_DISTRO})

# specify the cross compiler
set(CMAKE_C_COMPILER "/usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-gcc")
set(CMAKE_CXX_COMPILER "/usr/bin/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu-g++")

set(_pkgconfig_paths)
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/usr/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu/pkgconfig")
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/usr/lib/openmpi/lib/pkgconfig")
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/usr/lib/pkgconfig")
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/usr/share/pkgconfig")
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/opt/ros/${ROS_DISTRO}/lib/${CMAKE_SYSTEM_PROCESSOR}-linux-gnu/pkgconfig")
list(APPEND _pkgconfig_paths "${CMAKE_SYSROOT}/opt/ros/${ROS_DISTRO}/lib/pkgconfig")
string(REPLACE ";" ":" _pkgconfig_paths "${_pkgconfig_paths}")
set(ENV{PKG_CONFIG_PATH} "${_pkgconfig_paths}")

# where is the target environment
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

# This assumes that pthread will be available on the target system
# (this emulates that the return of the TRY_RUN is a return code "0"
set(THREADS_PTHREAD_ARG "0"
  CACHE STRING "Result from TRY_RUN" FORCE)

set(Numpy_INCLUDE_DIRS "${CMAKE_SYSROOT}/usr/lib/python2.7/dist-packages/numpy/core/include")

set(CYTHON_EXECUTABLE $ENV{AUTOWARE_CYTHON_EXECUTABLE})
set(CUDA_ARCH $ENV{AUTOWARE_CUDA_ARCH})

# Required for mrt_cmake_modules
set(MRT_ARCH "armv8-a")
