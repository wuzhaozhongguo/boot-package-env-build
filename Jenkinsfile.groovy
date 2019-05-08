//docker构建环境镜像命名空间
PARAM_DOCKER_IMAGE_NAMESPACE=""
//docker构建环境镜像名称
PARAM_DOCKER_IMAGE_NAME=""
//docker构建环境镜像版本
PARAM_DOCKER_IMAGE_VERSION="latest"
//git url
PARAM_GIT_URL=""
//构建邮件通知(多个","号隔开)
PARAM_BUILD_MAIL=""

@Library('jenkins-pipeline-library') _

def mapConfig = ["PARAM_DOCKER_IMAGE_NAMESPACE":PARAM_DOCKER_IMAGE_NAMESPACE,
                 "PARAM_DOCKER_IMAGE_NAME":PARAM_DOCKER_IMAGE_NAME,
                 "PARAM_DOCKER_IMAGE_VERSION":PARAM_DOCKER_IMAGE_VERSION,
                 "PARAM_GIT_URL":PARAM_GIT_URL,
                 "PARAM_BUILD_MAIL":PARAM_BUILD_MAIL,
]
dockerfileBuild(mapConfig)