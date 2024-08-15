# pgfried

This application creates one connection per second to a PostgreSQL database,
deliberatingly avoiding di close it.

It's use case is to test how your system reacts when the connections are
exhausted.

**IMPORTANT** this application should never see a production environment

## How to setup a development environment

Take a look to [the Haskell Template
documentation](https://srid.ca/haskell-template/start), everything is there.

## How to build a docker image

Easy as a piece of cake, and documented in the [flake
parts](https://community.flake.parts/haskell-flake/docker) documentation:

```
$ just dockerImage
[...]
/nix/store/6pfbdc6jlqwnyl208vkigw1ik23ifg7v-docker-image-pgfried.tar.gz
```
