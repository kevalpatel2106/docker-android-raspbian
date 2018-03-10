#
# GitLab CI: Android v0.2
#
# https://hub.docker.com/r/showcheap/gitlab-ci-android/
#

FROM resin/raspberry-pi-openjdk:openjdk-8-jdk

RUN apt-get install -y unzip

ENV VERSION_BUILD_TOOLS "26.0.2"
ENV VERSION_TARGET_SDK "26"

# Define working directory
WORKDIR /data

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-armhf

# Download SDK
ADD https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip /tools.zip
RUN unzip /tools.zip -d /sdk && \
    rm -v /tools.zip

# Configure PATH
ENV ANDROID_HOME "/sdk"
ENV PATH "${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools"

# Accept License
RUN mkdir -p $ANDROID_HOME/licenses/ && \
    echo "8933bad161af4178b1185d1a37fbf41ea5269c55\nd56f5187479451eabf01fb78af6dfcb131a6481e" > $ANDROID_HOME/licenses/android-sdk-license && \
    echo "84831b9409646a918e30573bab4c9c91346d8abd" > $ANDROID_HOME/licenses/android-sdk-preview-license

# Install SDK Package
RUN sdkmanager build-tools-${VERSION_BUILD_TOOLS}
RUN sdkmanager android-${VERSION_TARGET_SDK}
RUN sdkmanager "platform-tools" --verbose && \
RUN sdkmanager "extras;android;m2repository" --verbose && \
RUN sdkmanager "extras;google;m2repository" --verbose && \
RUN sdkmanager "extras;google;google_play_services" --verbose && \
RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.2" --verbose && \
RUN sdkmanager "extras;m2repository;com;android;support;constraint;constraint-layout;1.0.1" --verbose