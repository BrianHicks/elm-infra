# Making a Site Update

The files used to make builds are in the `docker` directory, inside some `Dockerfile`s.
See also the "quick Dockerfile reference" at the end of this document for our use, [the Docker documentation](https://docs.docker.com/engine/reference/builder/) has the rest.

These instructions apply to both the elm-lang.org and package.elm-lang.org images.
There are minor variations, but they're not too bad.

1. Make your changes and verify them locally

2. If your changes require a newer/different version of the Elm compiler, change `docker/elm-dev/Dockerfile` to build the new Elm platform.
   You might be able to skip this if the different version is already published!
   Check for the tag you want on Docker Hub for [Brian](https://hub.docker.com/r/brianhicks/elm-dev/tags/) and wherever else we've published images.

3. Change the `VERSION` and `SITE_VERSION` arguments at the top of the build script.
   If the build instructions have changed, you may need to update those as well at this time.

4. If there are new files or old ones have gone away, change them in the block of `COPY` instructions at the bottom.

5. Build locally by running `docker build -t {yourname}/{imagename}:{version} docker/{imagename}`, where:

   - `{yourname}` is your username on the docker hub.
     You can leave this off if you're just testing, and tag later with `docker tag {originalname} {newname}`
   - `{imagename}` is the name of the image.
   - `{version}` is a descriptive tag.
     This can contain dots, dashes, and alphanumeric characters, so be as specific as you like.
     The images published now (before the release of 0.19) are all tagged as `0.18.0`.
     It would be good to add a version at the end of that, like `0.19.0-20171001`.
     It doesn't matter if the tags are lexically sortable, but it's nice and can help organize.

6. Test locally by running `docker run -p 8000:8000 {imageyoubuilt} {optional command}`, where:

   - `{imageyoubuilt}` is the full name of the image you built in the last step, including the tag.
   - `{optional command}` is a command to run inside the container.
   - `-p 8000:8000` is a port directive.
     The first port is the host port, and the second is the container port.
     This particular invocation forwards container port 8000 to host port 8000, so you can browse the site at localhost:8000.

7. If everything looks good, publish the image (`docker push {imagename}`) and then update the compose file for the service you're working with.
   It's probably enough to tell it what the new fully-qualified image of the service is (at `services.{name}.image`), but if you need to set more environment variables or change invocation arguments, this is where to do it.
   If you need to add more things, the [Docker Compose file version 3 reference](https://docs.docker.com/compose/compose-file/) has *everything*.
   If you need something more specific, ask Brian or someone who's worked on those files before (check git history.)

8. Time to deploy!
   Copy the files to the server and run `docker stack deploy --prune --compose-file path/to/your.yaml name-of-your-yaml`
   You can find the name with `docker stack ls`.
   We add `--prune` to deploy the exact set of services in the file (but you can probably leave it off if you haven't removed any services from the stack.)
   Once you run this, you can monitor the status of the deployment with `docker stack ps {name}`.

9. Test the live version!
   If you need to revert, revert locally and upload the last version, then deploy using the same method.
   If you need to debug, look at the logs by getting the process ID from `docker stack ps {name}` and then `docker logs -f {docker_id}`

## Quick Dockerfile Reference

- `FROM` specifies a base image.
  Several of our files have more than one of these.
  This resets the build context to bring the built size down.
  In many cases, we would be shipping all the intermediate files and dependencies from the Haskell build process without these resets.

- `ARG` is an argument you can modify when building the container (with `--build-arg KEY=VALUE` flag), which will be available as an environment variable to subsequent commands.

- `RUN` runs a command in a shell.

  It's usually on one line, but you can escape newlines with `\` and `;` or `&&` to get multi-line commands.

- `COPY` copies files either from the build directory (by default, the same directory the `Dockerfile` lives in) or previous runs.

- `WORKDIR` sets the working directory for subsequent commands

- `EXPOSE` exposes a port in the final built image.
  This is not exposed to the world by default, but it lets Docker know how to route it.

- `CMD` is the default command to run.
  We use this instead of `ENTRYPOINT` because `ENTRYPOINT` is more suitable for invoke-once tools instead of long-running processes.
