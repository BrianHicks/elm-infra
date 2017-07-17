# TODO: get it so that images are built and tracked here
.PHONY: test
test:
	./assert.sh dev/assertions "brianhicks/elm-dev:0.18.0"
