# TODO: get it so that images are built and tracked here
.PHONY: test
test:
	./assert.sh dev/assertions "brianhicks/elm-dev:0.18.0"
	./assert.sh elm-lang.org/assertions "brianhicks/elm-lang.org:0.18.0"
