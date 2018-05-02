#!/usr/bin/env bash

IMAGE_NAME="cs512/easycrypt"

# Escalated privileges necessary to interface with Docker
# (though on macOS, Docker doesn't need sudo)
if ! [[ "$(uname)" =~ "Darwin" ]]
then
   [[ $EUID != 0 ]] && {
      echo "$(tput setaf 3)Escalating to root...$(tput sgr0)"
      exec sudo /usr/bin/env bash "$0" "$@"
   }
fi

# Check to see if we have Docker
which docker &>/dev/null || {
   >&2 echo "$(tput setaf 1)Please install Docker.$(tput sgr0)"
   exit 1
}

# Do nothing if Docker isn't running
docker info &>/dev/null || {
   >&2 echo "Can't connect to the Docker daemon. Is it running?"
   exit 2
}

# See if the image has been built
if ! docker images | sed 1d | cut -f1 -d" " | grep -iq "$IMAGE_NAME"
then
   >&2 cat << EOF
You don't seem to have the CS 512 EasyCrypt image built (or it's under a different name). Navigate to this directory and run

   $(tput setaf 2)docker build -t "$IMAGE_NAME" .$(tput sgr0)

and then try running this again, bearing in mind that the build process will take a while.
EOF
   exit 3
fi

# Don't launch another container if there is run already running
docker ps -a | sed 1d | grep -iq "cs512-easycrypt-box-.*" && {
   >&2 echo "An instance of $IMAGE_NAME is already running. Please remove it before running this script again."
   exit 4
}

# Run Docker image; --rm flag provided so that container self-destructs after quitting
exec docker run \
   -it \
   -e TERM \
   --name "$(printf -- "$IMAGE_NAME" | tr '/' '-')-box-$(date +%Y-%m-%d-%H%M%S%z)" \
   -v "$PWD/shared":/home/opam/shared \
   --rm \
   -- "$IMAGE_NAME" "$@"
