# Don't use onbuild image for now because we have to inject a couple of workarounds
# before `mvn install` runs.
FROM maven:3.3-jdk-7

MAINTAINER Chris Kilding <chris.kilding@mendeley.com>

# Create a place in the container to put the folder of app code, and Maven configs
RUN mkdir -p /usr/src/app
RUN mkdir -p /usr/src/app/.ci

# Everything we do from now on is in the context of this folder
WORKDIR /usr/src/app

# Put the Maven configs into this base image
ADD settings.xml /usr/src/app/.ci/

# Put all the contents of the git repo into the container
ONBUILD ADD . /usr/src/app

# Workaround - Vagrant system is deprecated so this value is still required, but unused
# TODO remove this line when Vagrant is removed from build setup
# Be sure to set this *before* running mvn install
ENV MENDELEY_PUPPET_PATH ""

# Workaround - use our special settings.xml in the container when running mvn commands
# Workaround - DO NOT run the integration tests as they will fail at image build stage
ONBUILD RUN mvn -s .ci/settings.xml package

# The child app will define a CMD; we cannot predict this ahead of time.