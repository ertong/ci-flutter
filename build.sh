SDK_VER=33
SDK_TOOLS_VER=33.0.2
FLUTTER_VER=3.16.5

TAG=$FLUTTER_VER-api$SDK_VER

#docker build --no-cache \
docker build --pull\
  --build-arg flutter_version=$FLUTTER_VER \
  --build-arg sdk_version=$SDK_VER \
  --build-arg sdk_tools_version=$SDK_TOOLS_VER \
  -t ertong/flutter:$TAG . || exit 1

docker push ertong/flutter:$TAG