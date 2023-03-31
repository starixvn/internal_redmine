FROM hub.nexdev.net/nexus/nexdev_base

RUN rm -r /app/redmine/*
COPY . /app/redmine/
WORKDIR /app/redmine
RUN mkdir tmp
RUN chmod 777 /app/redmine/tmp
