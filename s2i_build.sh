#!/usr/bin/env bash
#
# This script replicates a s2i build process performed via buildah
#
set -e

BUILD_IMAGE="registry.redhat.io/jboss-webserver-5/jws56-openjdk11-openshift-rhel8"
USER="jboss"
S2I_SCRIPTS_URL="/usr/local/s2i/"
OUTPUT_IMAGE="helloservlet"
INCREMENTAL=true

#Define ENV variables that you want to inject, and list in ENVIRONMENTS separated by comma
ENVIRONMENTS=""

echo "Start"
builder=$(buildah from $BUILD_IMAGE)

buildah add --chown $USER:0 $builder ./ /tmp/src

if [ "$INCREMENTAL" = "true" ]; then

    if [ -f "./artifacts.tar" ]; then
        echo "Restoring artifacts"
        buildah add --chown $USER:0 $builder ./artifacts.tar /tmp/artifacts
    fi

fi

COMMAND=""

if [ -n "$ENVIRONMENTS" ]; then

    COMMAND+="buildah config "

    IFS=','; for word in $ENVIRONMENTS; do COMMAND+="--env $word=${!word} "; done

    COMMAND+='$builder'

fi

if [ ! -z "$COMMAND" ]; then
    echo "Executing $COMMAND"

    eval "$COMMAND"
fi

buildah config --cmd $S2I_SCRIPTS_URL/run $builder

if [ -x ".s2i/bin/assemble" ]; then
    echo "Using assemble from .s2i"
    buildah run $builder -- /tmp/src/.s2i/bin/assemble
else
    echo "Using assemble from image"
    buildah run $builder -- $S2I_SCRIPTS_URL/assemble
fi

if [ "$INCREMENTAL" = "true" ]; then

    echo "saving artifacts"
    if [ -f "./artifacts.tar" ]; then
        rm ./artifacts.tar
    fi

    buildah run $builder -- /bin/bash -c 'if [ -x "/usr/local/s2i/save-artifacts" ]; then /usr/local/s2i/save-artifacts ; fi' > ./artifacts.tar

fi

buildah commit $builder $OUTPUT_IMAGE

buildah rm $builder