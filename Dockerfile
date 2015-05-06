# Don't use onbuild image for now because we have to inject a couple of workarounds
# before `mvn install` runs.
FROM maven:3.3-jdk-7

MAINTAINER Chris Kilding <chris.kilding@mendeley.com>

# Create a place in the container to put this folder of app code
RUN mkdir -p /usr/src/app

# Everything we do from now on is in the context of this folder
WORKDIR /usr/src/app

# Put the Maven configs into this base image
RUN mkdir -p /usr/src/app/.ci
ADD settings.xml /usr/src/app/.ci/

# Put all the contents of the git repo into the container
ONBUILD ADD . /usr/src/app

# Workaround - Vagrant system is deprecated so this value is still required, but unused
# TODO remove this line when Vagrant is removed from build setup
# Be sure to set this *before* running mvn install
ENV MENDELEY_PUPPET_PATH ""

# Workaround - add our special settings.xml to the container BEFORE running mvn commands
# Workaround - DO NOT run the integration tests as they will fail at image build stage
ONBUILD RUN mvn -s .ci/settings.xml install -DskipITs

# FIXME we use this wrapper script to pretend that ConfiguredCommandCommand can accept
# its variables from an env var (when currently it can only read from a file).
# When ConfiguredCommandCommand is improved, we can just use something like
# CMD ["mvn -s .ci/settings.xml exec:exec [with some env vars in the system]
# and ditch the wrapper script.
CMD ["./run-server.sh"]