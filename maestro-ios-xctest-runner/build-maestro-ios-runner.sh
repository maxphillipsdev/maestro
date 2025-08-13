#!/usr/bin/env bash
set -euo pipefail

if [ "$(basename "$PWD")" != "maestro" ]; then
	echo "This script must be run from the maestro root directory"
	exit 1
fi

rm -rf ./build/Products

# Determine build output directory
if [[ "$DESTINATION" == *"iOS Simulator"* ]]; then
	BUILD_OUTPUT_DIR="Debug-iphonesimulator"
elif [[ "$DESTINATION" == *"tvOS Simulator"* ]]; then
	BUILD_OUTPUT_DIR="Debug-appletvsimulator"
else
	BUILD_OUTPUT_DIR="Debug-iphoneos"
fi

if [[ "$DESTINATION" == *"iOS Simulator"* ]]; then
  DEVELOPMENT_TEAM_OPT=""
elif [[ "$DESTINATION" == *"tvOS Simulator"* ]]; then
  DEVELOPMENT_TEAM_OPT=""
else
  echo "Building iphoneos drivers for team: ${DEVELOPMENT_TEAM}..."
	DEVELOPMENT_TEAM_OPT="DEVELOPMENT_TEAM=${DEVELOPMENT_TEAM}"
fi

## Remove intermediates, output and copy runner in maestro-ios-driver
cp -r \
	./build/Products/Debug-iphonesimulator/maestro-driver-iosUITests-Runner.app \
	./maestro-ios-driver/src/main/resources/ios/maestro-driver-iosUITests-Runner.app

cp -r \
	./build/Products/Debug-appletvsimulator/maestro-driver-iosUITests-Runner.app \
	./maestro-ios-driver/src/main/resources/tvos/maestro-driver-iosUITests-Runner.app

cp -r \
	./build/Products/Debug-iphonesimulator/maestro-driver-ios.app \
	./maestro-ios-driver/src/main/resources/ios/maestro-driver-ios.app

cp -r \
	./build/Products/Debug-appletvsimulator/maestro-driver-ios.app \
	./maestro-ios-driver/src/main/resources/tvos/maestro-driver-ios.app

cp \
	./build/Products/*iphonesimulator*.xctestrun \
	./maestro-ios-driver/src/main/resources/ios/maestro-driver-ios-config.xctestrun

cp \
	./build/Products/*appletvsimulator*.xctestrun \
	./maestro-ios-driver/src/main/resources/tvos/maestro-driver-ios-config.xctestrun

(cd ./maestro-ios-driver/src/main/resources/ios && zip -r maestro-driver-iosUITests-Runner.zip ./maestro-driver-iosUITests-Runner.app)
(cd ./maestro-ios-driver/src/main/resources/tvos && zip -r maestro-driver-iosUITests-Runner.zip ./maestro-driver-iosUITests-Runner.app)
(cd ./maestro-ios-driver/src/main/resources/ios && zip -r maestro-driver-ios.zip ./maestro-driver-ios.app)
(cd ./maestro-ios-driver/src/main/resources/tvos && zip -r maestro-driver-ios.zip ./maestro-driver-ios.app)
rm -r ./maestro-ios-driver/src/main/resources/ios/*.app
rm -r ./maestro-ios-driver/src/main/resources/tvos/*.app
