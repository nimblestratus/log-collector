# Log Collector
#
# VERSION 0.0.1
#
# Uses octopussy for its log aggregation


FROM base
MAINTAINER Matt Williams "matt@nimblestrat.us"

RUN apt-get update

# install supervisor
# Eventually this and other "standard" pieces will be in their own dockerfile
RUN apt-get install python-setuptools 
RUN easy_install supervisor

# install octopussy
RUN wget -o octopussy_1.0.10_all.deb http://sourceforge.net/projects/syslog-analyzer/files/octopussy_1.0.10_all.deb/download
ENV DEBIAN_FRONTEND=noninteractive
RUN dpkg -i octopussy_1.0.10_all.deb
# need to determine how to not be prompted to change mysql password
RUN apt-get -f -q -y install

# configure supervisor:
#  + apache
#  + mysql
#  + rsyslog
#  + octopussy

ADD files/rsyslog.conf /etc/rsyslog.conf
ADD files/httpd.conf /etc/httpd.conf

# generate certificate for Octopussy Web Server
RUN openssl genrsa > /etc/octopussy/server.key
RUN openssl req -new -x509 -nodes -sha1 -days 365 -key /etc/octopussy/server.key > /etc/octopussy/server.crt

# Ports we need
EXPOSE 80,514

