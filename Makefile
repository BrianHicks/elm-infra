VERSION=0.18

brianhicks/%: %/*
	docker build --build-arg VERSION=${VERSION} -t $@:${VERSION} $*
	@mkdir -p $@ && touch -m $@

brianhicks/elm-lang.org: brianhicks/elm-dev

.PHONY: clean
clean:
	rm -rf brianhicks

.PHONY: test
test: brianhicks/elm-dev brianhicks/elm-lang.org
	./assert.sh elm-dev/assertions "brianhicks/elm-dev:0.18.0"
	./assert.sh elm-lang.org/assertions "brianhicks/elm-lang.org:0.18.0"
