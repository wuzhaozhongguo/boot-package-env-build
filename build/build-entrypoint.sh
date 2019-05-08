#! /bin/sh -eu
set -eo pipefail
cd ${BASE_PATH}

MAVEN_P=""
if [ ${MAVEN_PROFILE} ]; then
  MAVEN_P="-P${MAVEN_PROFILE}"
fi

clone_and_package() {
    #create build job folder
    mkdir -p ${BASE_PATH}/${PACKAGE_FOLDER_NAME}/${BUILD_ID}/
    # to code foloder
    cd ${BASE_PATH}/${CODE_FOLDER_NAME}
    git clone ${TOKEN_GIT_URL}
    # change code foloder name
    mv ${BASE_PATH}/${CODE_FOLDER_NAME}/$(ls -A1 ${BASE_PATH}/${CODE_FOLDER_NAME}/) ${BASE_PATH}/${CODE_FOLDER_NAME}/${CODE_FOLDER_NAME}
    cd ${BASE_PATH}/${CODE_FOLDER_NAME}/${CODE_FOLDER_NAME}
    mvn -Dmaven.test.skip=true clean package -U ${MAVEN_P}
    cp ${BASE_PATH}/${CODE_FOLDER_NAME}/${CODE_FOLDER_NAME}/target/*.jar \
    ${BASE_PATH}/${PACKAGE_FOLDER_NAME}/${BUILD_ID}/app.jar
}

owd="$(pwd)"
clone_and_package

cd "${owd}"
unset owd
exec "$@"
