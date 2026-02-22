CC = clang
SDK = $(shell xcrun --sdk iphoneos --show-sdk-path)

cemobile.dylib: Tweak.c
	$(CC) -arch arm64 -arch arm64e \
		-isysroot $(SDK) \
		-framework Foundation \
		-framework UIKit \
		-dynamiclib \
		-fobjc-arc \
		-o $@ $<
	ldid -S $@

clean:
	rm -f *.dylib

.PHONY: clean
