# This file is a template, and might need editing before it works on your project.
FROM registry.nexdev.net:5050/nexcel/nexus/nexdev

RUN rm -r /app/redmine/*
COPY . /app/redmine/
