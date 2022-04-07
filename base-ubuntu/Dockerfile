FROM ubuntu:20.04
MAINTAINER muyi zcy_nemo@aliyun.com
LABEL Description="Ubuntu base image 1.0 <路漫漫其修远兮，吾将上下而求索>"

ARG JAVA_VERSION=8
ARG JAVA_RELEASE=JDK

RUN bash -c ' \
    set -euxo pipefail && \
    apt-get update && \
    pkg="openjdk-$JAVA_VERSION"; \
    if [ "$JAVA_RELEASE" = "JDK" ]; then \
        pkg="$pkg-jdk-headless"; \
    else \
        pkg="$pkg-jre-headless"; \
    fi; \
    apt-get install -y --no-install-recommends "$pkg" && \
    apt-get clean'

ENV JAVA_HOME=/usr

CMD ["/bin/bash"]