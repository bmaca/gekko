FROM node:8

ENV HOST localhost
ENV PORT 3000

# Create app directory
RUN mkdir -p /home/docker_user

# Create an app user so the program doesn't run as root.
RUN groupadd -r docker_user &&\
  useradd -r -g docker_user -d /home/docker_user -s /sbin/nologin -c "Docker image user" docker_user

# Setting up the app
ENV APP_HOME=/home/docker_user/app
RUN mkdir $APP_HOME
WORKDIR ${APP_HOME}


# Install GYP dependencies globally, will be used to code build other dependencies
RUN npm install -g --production node-gyp && \
  npm cache clean --force

# Install Gekko dependencies
COPY package.json .
RUN npm install --production && \
  npm install --production redis@0.10.0 talib@1.0.2 tulind@0.8.7 pg && \
  npm cache clean --force

# Install Gekko Broker dependencies
WORKDIR exchange
COPY exchange/package.json .
RUN npm install --production && \
  npm cache clean --force
WORKDIR ../

# Bundle app source
COPY . ${APP_HOME}

# Chown all the files to the app user.
RUN chown -R docker_user:docker_user $APP_HOME

EXPOSE 3000
# change to the docker_user
USER docker_user

RUN chmod +x ${APP_HOME}/docker-entrypoint.sh
# runs the app as the docker_user
ENTRYPOINT ["/home/docker_user/app/docker-entrypoint.sh"]

CMD ["--config", "config.js", "--ui"]
