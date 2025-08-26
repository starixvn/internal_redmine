FROM hub.nexdev.net/nexus/nexdev_base
RUN set -x \
 	&& apt-get update \
     && apt-get -y install nano \
     && apt-get -y install curl \
     && apt-get -y install telnet

# Remove existing directory and copy new one (without trailing slash to overwrite)
COPY . /app/redmine

# Copy nginx configuration
COPY nginx.conf /opt/nginx/conf/nginx.conf

# Set working directory and create temp directory
WORKDIR /app/redmine
RUN mkdir -p tmp && chmod 777 tmp