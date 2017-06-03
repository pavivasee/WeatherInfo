default:
	xcodebuild -arch i386 -sdk iphonesimulator9.0 -workspace WeatherInfo.xcworkspace -scheme WeatherInfoNew ONLY_ACTIVE_ARCH=NO VALID_ARCHS="i386 x86_64"

clean:
		-rm -rf build/*

