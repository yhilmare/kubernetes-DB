FROM ubuntu:16.04

MAINTAINER ILMARE "yhswjtu_163.com"

RUN mkdir -p /mountDir/initdir

RUN mkdir -p /volumeDir/data

RUN mkdir -p /volumeDir/logs

RUN mkdir -p /volumeDir/conf

COPY run.sh /run.sh

ENTRYPOINT ["/run.sh"]
