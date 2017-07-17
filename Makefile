VERSION=0.18
TAG_VERSION=0.18.0

brianhicks/%: %/*
	docker build --build-arg VERSION=${VERSION} -t $@:${TAG_VERSION} $*
	@mkdir -p $@ && touch -m $@

brianhicks/elm-lang.org: brianhicks/elm-dev

.PHONY: clean
clean:
	rm -rf brianhicks

.PHONY: test
test: brianhicks/elm-dev brianhicks/elm-lang.org brianhicks/package.elm-lang.org
	./assert.sh elm-dev/assertions "brianhicks/elm-dev:${TAG_VERSION}"
	./assert.sh elm-lang.org/assertions "brianhicks/elm-lang.org:${TAG_VERSION}"
	./assert.sh package.elm-lang.org/assertions "brianhicks/package.elm-lang.org:${TAG_VERSION}"
