SDK_VER=34
FLUTTER_VER=3.24.3

# for some reason, all these will be downloaded on the build stage anyway
ANDROID_PACKAGES="platforms;android-29 platforms;android-30 platforms;android-31 platforms;android-32 platforms;android-33 platforms;android-34"
ANDROID_PACKAGES="$ANDROID_PACKAGES build-tools;30.0.3 build-tools;33.0.1 build-tools;34.0.0"

TAG=$FLUTTER_VER-api$SDK_VER

docker buildx build --pull \
  --build-arg FLUTTER_VERSION=$FLUTTER_VER \
  --build-arg "ANDROID_PACKAGES=$ANDROID_PACKAGES" \
  -t ertong/flutter:$TAG . || exit 1

docker push ertong/flutter:$TAG