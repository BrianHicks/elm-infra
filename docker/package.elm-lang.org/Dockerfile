FROM brianhicks/elm-base:0.18.0 as build

ARG VERSION=0.18
ARG SITE_VERSION=$VERSION.0

# get the base
RUN git clone https://github.com/elm-lang/package.elm-lang.org.git /src/Elm-Platform/$VERSION/package.elm-lang.org
WORKDIR /src/Elm-Platform/$VERSION/package.elm-lang.org
RUN git checkout $SITE_VERSION
ADD run-server.cabal .

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

COPY --from=build /src/Elm-Platform/$VERSION/package.elm-lang.org/elm-package.json /app/elm-package.json
COPY --from=build /src/Elm-Platform/$VERSION/package.elm-lang.org/src/frontend /app/src/frontend
COPY --from=build /src/Elm-Platform/$VERSION/package.elm-lang.org/assets /app/assets
COPY --from=build /src/Elm-Platform/$VERSION/package.elm-lang.org/dist/build/run-server/run-server /bin/run-server
COPY --from=build /src/Elm-Platform/$VERSION/.cabal-sandbox/bin/elm-make /bin/elm-make

CMD ["run-server", "-p", "8000"]
EXPOSE 8000
