PROJECT = xkcd.xcodeproj

generate-xcodeproj:
	@echo "Generating xcode project"
	rm -rf $(PROJECT)
	xcodegen
