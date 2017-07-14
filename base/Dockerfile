FROM haskell:7.10
# TODO: 8.0.2 is the latest. Use that?

RUN apt-get update && apt-get install --assume-yes git

ADD https://raw.githubusercontent.com/elm-lang/elm-platform/master/installers/BuildFromSource.hs /src/BuildFromSource.hs
RUN runhaskell /src/BuildFromSource.hs 0.18

ENV PATH=$PATH:/Elm-Platform/0.18/.cabal-sandbox/bin
