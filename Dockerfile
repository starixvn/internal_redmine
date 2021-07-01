# This file is a template, and might need editing before it works on your project.
FROM registry.nexdev.net:5050/nexcel/nexus/nexdev

COPY . /app/redmine/
RUN chmod -R 777  /app/redmine/public/