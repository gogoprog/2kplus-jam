build:
	haxe build.hxml
	mkdir -p build
	cat src/before.html > build/app.html
	cat temp/main.js >> build/app.html
	cat src/after.html >> build/app.html

retail:
	haxe build.hxml
	mkdir -p retail
	uglifyjs --compress --mangle -- temp/main.js > temp/main.min.js
	cat src/before.html > retail/app.html
	cat temp/main.min.js >> retail/app.html
	cat src/after.html >> retail/app.html
	stat retail/app.html | grep Size

zip: retail
	zip -r game.zip retail

.PHONY: build retail
