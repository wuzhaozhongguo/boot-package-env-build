#!/usr/bin/env bash
#仓库命名空间domain/namespace
BUILD_IMAGE_REPO=""
#镜像名称
BUILD_NAME="boot-package"
#版本
BUILD_VERSION="latest"

BUILD_IMAGE_NAME="${BUILD_IMAGE_REPO}/${BUILD_NAME}"

docker build -t="${BUILD_IMAGE_NAME}:${BUILD_VERSION}" .