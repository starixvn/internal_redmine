FROM hub.nexdev.net/nexus/nexcel-redmine333-base

RUN rm -r /usr/src/redmine/plugins/* 
RUN rm -r /usr/src/redmine/config/* 
RUN rm -r /usr/src/redmine/public/*
RUN rm -r /usr/src/redmine/lib/*

COPY ./plugins/ /usr/src/redmine/plugins/
COPY ./config/ /usr/src/redmine/config/
COPY ./public/ /usr/src/redmine/public/
COPY ./lib/ /usr/src/redmine/lib/
COPY ./avatars/ /usr/src/redmine/avatars/

RUN mkdir -p /usr/src/redmine/log && chmod -R 777 /usr/src/redmine/log

COPY ./Gemfile /usr/src/redmine/Gemfile
COPY ./Gemfile.lock /usr/src/redmine/Gemfile.lock

RUN chmod -R 777 /usr/src/redmine

