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

# package
FROM haskell:7.10 as package

COPY --from=build /src/Elm-Platform/0.18/elm-lang.org/dist/build/run-elm-website/run-elm-website /bin/run-elm-website
ENV PORT=8000
CMD ["run-elm-website", "-p", "$PORT"]
EXPOSE $PORT
