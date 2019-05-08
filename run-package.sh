#!/usr/bin/env bash
#构建产物目录
BUILD_PACKAGE_BASE_PATH="/var/lib/boot-build"
#app镜像名称
BUILD_ID="dev-boot-demo"
#giturl
TOKEN_GIT_URL=""
#构建工具镜像仓库命名空间domain/namespace
BUILD_IMAGE_REPO=""
#构建工具镜像名称
BUILD_NAME="boot-package"

BUILD_IMAGE_NAME="${BUILD_IMAGE_REPO}/${BUILD_NAME}"
docker run --rm  \
-e TOKEN_GIT_URL="${TOKEN_GIT_URL}" \
-e BUILD_ID="${BUILD_ID}" \
--name="boot-package-run-temp" \
-v maven-repo:/root/.m2/repository \
-v "${BUILD_PACKAGE_BASE_PATH}":/app/package \
"${BUILD_IMAGE_NAME}"