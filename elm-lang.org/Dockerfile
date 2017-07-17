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
ENV PATH=$PATH:/src/Elm-Platform/$VERSION/elm-lang.org/dist/build/run-elm-website

# run
CMD ["run-elm-website", "-p", "8000"]
EXPOSE 8000
