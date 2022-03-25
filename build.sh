#!/bin/bash

# Build script of docker-gcc-cmake

os_list=(
  ubuntu
  debian
)

ubuntu_version_list=(
  14.04
  trusty
  16.04
  xenial
  18.04
  bionic
  20.04
  focal
  22.04
  jammy
)

debian_version_list=(
  8
  jessie
  9
  strech
  10
  buster
  11
  bullseye
)

# Create empty context
mkdir -p dockerfiles nul

for os in ${os_list[@]};
do
  version_list_name=${os}_version_list
  eval version_list=\${$version_list_name[@]}
  for version in ${version_list};
  do
    echo "Using ${os}-${version}"
    sed "s/__IMAGE__/${os}/g; s/__TAG__/${version}/g" Dockerfile.tmpl > dockerfiles/Dockerfile-${os}-${version}
    docker build --no-cache -t ilharp/gcc-cmake:${os}-${version} -f dockerfiles/Dockerfile-${os}-${version} nul
  done
done

echo "Build complete. Now pushing images."
docker push -a ilharp/gcc-cmake
