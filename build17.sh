SDK_VER=35
FLUTTER_VER=3.29.0

# for some reason, all these will be downloaded on the build stage anyway
ANDROID_PACKAGES="platforms;android-30 platforms;android-33 platforms;android-34 platforms;android-35"
ANDROID_PACKAGES="$ANDROID_PACKAGES build-tools;34.0.0 build-tools;35.0.0 ndk;27.0.12077973 cmake;3.22.1"


TAG=$FLUTTER_VER-api$SDK_VER-jdk17

docker buildx build --pull \
  --build-arg FLUTTER_VERSION=$FLUTTER_VER \
  --build-arg JDK_PACKAGE=openjdk-17-jdk \
  --build-arg "ANDROID_PACKAGES=$ANDROID_PACKAGES" \
  -t ertong/flutter:$TAG . || exit 1

docker push ertong/flutter:$TAG
