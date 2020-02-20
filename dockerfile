# http://tutorials.jenkov.com/docker/dockerfile.html

# The base image
FROM lambci/lambda:build-python3.7

# Install snowsql
COPY install-snowsql.sh /install-snowsql.sh

RUN /install-snowsql.sh

MAINTAINER   Data Analytics <data.analytics@tfgm.com>