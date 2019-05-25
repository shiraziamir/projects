FROM phusion/baseimage
FROM ubuntu:18.04

MAINTAINER Mofid Team
ENV NODE_ENV=staging

# Install Node.js and other dependencies
WORKDIR /opt/git/production/live/project-backend.git

RUN useradd -ms /bin/bash md && \ 
    apt-get update && \
    apt-get -y  install sudo curl git telnet iputils-ping net-tools vim && \
    curl -sL https://deb.nodesource.com/setup_8.x |  bash - && \
    apt-get install --yes nodejs && \
    rm -rf /var/lib/apt/lists/* && \
     npm install -g pm2 babel-cli babel-register babel-preset-es2015 babel-preset-stage-2 babel-core babel-polyfill && \
    mkdir -p /opt/git/production/live/project-backend.git && \
    chown -R md: /opt && \
    echo "md ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/md && \
    chmod 0440 /etc/sudoers.d/md


# Define working directory

USER md
ADD . /opt/git/production/live/project-backend.git

RUN sudo chown -R md: . && npm install

COPY docker-entrypoint.sh /
#ENTRYPOINT ["/docker-entrypoint.sh"]

# Run app
CMD pm2 start --no-daemon ecosystem.config.js --env $NODE_ENV
