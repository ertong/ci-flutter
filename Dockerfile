FROM ubuntu:24.04
#android tools from https://github.com/cirruslabs/docker-images-android/blob/master/sdk/tools/Dockerfile


USER root
SHELL ["/bin/bash", "-c"]

ENV ANDROID_HOME=/opt/android-sdk-linux \
    LANG=en_US.UTF-8 \
    LC_ALL=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    TZ=Europe/Kyiv\
    DEBIAN_FRONTEND=noninteractive

ENV ANDROID_SDK_ROOT=$ANDROID_HOME \
    PATH=${PATH}:${ANDROID_HOME}/cmdline-tools/latest/bin:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/emulator

# comes from https://developer.android.com/studio/#command-tools
ENV ANDROID_SDK_TOOLS_VERSION 11076708

ARG JDK_PACKAGE=openjdk-11-jdk

RUN set -o xtrace \
    && cd /opt \
    && apt-get update \
    && apt-get install -y locales locales-all \
    && apt-get install -y $JDK_PACKAGE \
    && apt-get install -y --no-install-recommends \
            wget zip unzip git openssh-client curl bc software-properties-common build-essential \
            ca-certificates tzdata \
            python3-pip python3-click python3-requests\
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* \
    \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_TOOLS_VERSION}_latest.zip -O android-sdk-tools.zip \
    && mkdir -p ${ANDROID_HOME}/cmdline-tools/ \
    && unzip -q android-sdk-tools.zip -d ${ANDROID_HOME}/cmdline-tools/ \
    && mv ${ANDROID_HOME}/cmdline-tools/cmdline-tools ${ANDROID_HOME}/cmdline-tools/latest \
    && rm android-sdk-tools.zip \
    \
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && sdkmanager platform-tools

ARG FLUTTER_VERSION
ARG ANDROID_PACKAGES

RUN yes | sdkmanager $ANDROID_PACKAGES

ENV FLUTTER_HOME=${HOME}/sdks/flutter
ENV FLUTTER_ROOT=$FLUTTER_HOME

ENV PATH ${PATH}:${FLUTTER_HOME}/bin:${FLUTTER_HOME}/bin/cache/dart-sdk/bin

RUN git clone --depth 1 --branch ${FLUTTER_VERSION} https://github.com/flutter/flutter.git ${FLUTTER_HOME}

RUN yes | flutter doctor --android-licenses \
    && flutter doctor \
    && chown -R root:root ${FLUTTER_HOME}

RUN flutter precache --android