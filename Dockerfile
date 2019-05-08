FROM alpine:3.9
#env pre
RUN { \
        echo 'http://mirrors.aliyun.com/alpine/v3.9/main/'; \
        echo 'http://mirrors.aliyun.com/alpine/v3.9/community/'; \
    } > /etc/apk/repositories
RUN apk update
RUN apk add curl openssh less

# set git
RUN apk add git
RUN mkdir /root/.ssh/
RUN touch /root/.ssh/known_hosts
COPY build/id_rsa /root/.ssh/
RUN chmod 700 /root/.ssh && chmod 600 /root/.ssh/*
RUN ssh-keyscan gitee.com >> /root/.ssh/known_hosts
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

# set jdk（https://github.com/docker-library/openjdk/blob/master/8/jdk/alpine/Dockerfile）
ENV LANG C.UTF-8
RUN { \
		echo '#!/bin/sh'; \
		echo 'set -e'; \
		echo; \
		echo 'dirname "$(dirname "$(readlink -f "$(which javac || which java)")")"'; \
	} > /usr/local/bin/docker-java-home \
	&& chmod +x /usr/local/bin/docker-java-home
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk
ENV PATH $PATH:/usr/lib/jvm/java-1.8-openjdk/jre/bin:/usr/lib/jvm/java-1.8-openjdk/bin
ENV JAVA_VERSION 8u201
ENV JAVA_ALPINE_VERSION 8.212.04-r0
RUN set -x \
	&& apk add --no-cache \
		openjdk8="$JAVA_ALPINE_VERSION" \
	&& [ "$JAVA_HOME" = "$(docker-java-home)" ]
# set maven (https://github.com/carlossg/docker-maven/blob/master/jdk-8/Dockerfile)
ARG MAVEN_VERSION=3.6.1
ARG USER_HOME_DIR="/root"
ARG SHA=b4880fb7a3d81edd190a029440cdf17f308621af68475a4fe976296e71ff4a4b546dd6d8a58aaafba334d309cc11e638c52808a4b0e818fc0fd544226d952544
ARG BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/${MAVEN_VERSION}/binaries
RUN mkdir -p /usr/share/maven /usr/share/maven/ref \
  && curl -fsSL -o /tmp/apache-maven.tar.gz ${BASE_URL}/apache-maven-${MAVEN_VERSION}-bin.tar.gz \
  && echo "${SHA}  /tmp/apache-maven.tar.gz" | sha512sum -c - \
  && tar -xzf /tmp/apache-maven.tar.gz -C /usr/share/maven --strip-components=1 \
  && rm -f /tmp/apache-maven.tar.gz \
  && ln -s /usr/share/maven/bin/mvn /usr/bin/mvn
ENV MAVEN_HOME /usr/share/maven
ENV MAVEN_CONFIG "$USER_HOME_DIR/.m2"
COPY build/settings.xml ${MAVEN_CONFIG}/

# clear
RUN rm -rf /var/lib/apt/lists/* && rm /var/cache/apk/*

#package
ENV BASE_PATH=/app
ENV PACKAGE_FOLDER_NAME=package
ENV CODE_FOLDER_NAME=code
RUN mkdir -p ${BASE_PATH} && mkdir -p ${BASE_PATH}/${PACKAGE_FOLDER_NAME} && mkdir -p ${BASE_PATH}/${CODE_FOLDER_NAME}
# use token or public
ENV TOKEN_GIT_URL = ''
ENV BUILD_ID = ''
ENV MAVEN_PROFILE = ''
COPY build/build-entrypoint.sh /build-entrypoint.sh
RUN chmod +x /build-entrypoint.sh
ENTRYPOINT ["/build-entrypoint.sh"]