FROM haskell:7.10 as build
# TODO: 8.0.2 is the latest. Use that?

ARG VERSION=0.18

RUN apt-get update && apt-get install --assume-yes git

ADD https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs /src/BuildFromSource.hs
RUN cd /src && runhaskell /src/BuildFromSource.hs $VERSION
WORKDIR /src/elm-Platform/$VERSION

ENV PATH=$PATH:/src/Elm-Platform/$VERSION/.cabal-sandbox/bin
