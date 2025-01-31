# syntax = docker/dockerfile:1.0.0-experimental
#FROM latonaio/l4t:latest
FROM python:3.9.6-slim-bullseye

# Definition of a Device & Service
ENV POSITION=Runtime \
    SERVICE=azure-face-api-identifier-python-kube \
    AION_HOME=/var/lib/aion
# ENV GRPC_TRACE=all
# ENV GRPC_VERBOSITY=DEBUG
# Setup Directoties
RUN mkdir -p /${AION_HOME}/$POSITION/$SERVICE

WORKDIR /${AION_HOME}/$POSITION/$SERVICE

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    git \
    openssh-client \
    libmariadb-dev \
    build-essential \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ADD . .

# Install dependencies
RUN pip3 install --upgrade pip
RUN git config --global url."git@bitbucket.org:".insteadOf "https://bitbucket.org/"
#RUN --mount=type=secret,id=ssh,target=/root/.ssh/id_rsa ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts
#  && pip3 install -U git+ssh://git@bitbucket.org/latonaio/AION-related-python-library.git
#RUN pip3 install -r ./requirements.txt

RUN mkdir -p /root/.ssh/ && touch /root/.ssh/known_hosts && ssh-keyscan -t rsa bitbucket.org >> /root/.ssh/known_hosts
RUN --mount=type=secret,id=ssh,target=/root/.ssh/id_rsa pip3 install -r requirements.txt







CMD ["sh", "entrypoint.sh"]


