FROM brianhicks/elm-base:0.18.0 as build

ARG VERSION=0.18
ARG SITE_VERSION=$VERSION

# get the base
RUN git clone https://github.com/elm-lang/elm-lang.org.git /src/Elm-Platform/$VERSION/elm-lang.org
WORKDIR /src/Elm-Platform/$VERSION/elm-lang.org
RUN git checkout $SITE_VERSION

# build
RUN cabal sandbox init --sandbox ../.cabal-sandbox
RUN cabal install --only-dependencies
RUN cabal configure
RUN cabal build

# package for runtime
FROM haskell:7.10

ARG VERSION=0.18

RUN mkdir /app
WORKDIR /app

COPY --from=build /src/Elm-Platform/$VERSION/elm-lang.org/elm-package.json /app/elm-package.json
COPY --from=build /src/Elm-Platform/$VERSION/elm-lang.org/src /app/src
COPY --from=build /src/Elm-Platform/$VERSION/elm-lang.org/assets /app/assets
COPY --from=build /src/Elm-Platform/$VERSION/elm-lang.org/dist/build/run-elm-website/run-elm-website /bin/run-elm-website
COPY --from=build /src/Elm-Platform/$VERSION/.cabal-sandbox/bin/elm /bin/elm
COPY --from=build /src/Elm-Platform/$VERSION/.cabal-sandbox/bin/elm-make /bin/elm-make
COPY --from=build /src/Elm-Platform/$VERSION/.cabal-sandbox/bin/elm-package /bin/elm-package

CMD ["run-elm-website", "-p", "8000"]
EXPOSE 8000
