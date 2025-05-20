FROM hub.nexdev.net/nexus/nexdev_base

RUN rm -r /app/redmine/*
COPY . /app/redmine/
WORKDIR /app/redmine
RUN mkdir tmp
RUN chmod 777 /app/redmine/tmp

RUN set -x \
 	&& apt-get update \
     && apt-get -y install nano \
     && apt-get -y install curl \
     && apt-get -y install telnet