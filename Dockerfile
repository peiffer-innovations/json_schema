####################
##   Dart Stage   ##
####################
FROM drydock-prod.workiva.net/workiva/dart2_base_image:1 as build


# setup ssh
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT

# Setting up ssh and ssh-agent for git-based dependencies
RUN mkdir /root/.ssh/ && \
  echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts" && \
  chmod 700 /root/.ssh/ && \
  umask 0077 && echo "$GIT_SSH_KEY" >/root/.ssh/id_rsa && \
  eval "$(ssh-agent -s)" && \
  ssh-add /root/.ssh/id_rsa

WORKDIR /build/

COPY . /build/


RUN timeout 5m dart pub get

FROM scratch