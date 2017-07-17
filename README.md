# Elm Infra

Running Elm's websites in Docker so we can compose them a little bit better for reliability, etc.

# Docker Images

## `elm-dev`

This contains the Elm platform in Docker. Mostly using [this guide](https://github.com/elm-lang/elm-platform/blob/master/README.md).

### `elm-lang.org`

[elm-lang.org](http://elm-lang.org/), packaged as minimally as possible (no compilation artifacts aside from the binaries we need, etc)

### `package.elm-lang.org`

[package.elm-lang.org](http://package.elm-lang.org/), packaged as minimally as possible.
There is a major caveat here: the current (0.18) implementation of the package site works off a couple JSON files on disk.
This is a problem scaling up, and we'll see if that changes in the future.
For now, we're going to pretend it's stateless and add statefulness as needed.
