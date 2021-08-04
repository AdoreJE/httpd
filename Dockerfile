# V1
#FROM centos:7
#
##RUN yum -y update && yum clean all
#RUN yum -y install httpd httpd-devel gcc* make && yum clean all
#
## Install mod_jk
#RUN curl -SL https://downloads.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-1.2.48-src.tar.gz -o tomcat-connectors-1.2.48-src.tar.gz \
#    && mkdir -p /src/tomcat-connectors \
#    && tar xzf tomcat-connectors-1.2.48-src.tar.gz -C src/tomcat-connectors --strip-components=1 \
#    && cd src/tomcat-connectors/native/ \
#    && ./configure --with-apxs=/usr/bin/apxs \
#    && make \
#    && cp apache-2.0/mod_jk.so /usr/lib64/httpd/modules/ \
#    && cd / \
#    && rm -rf src/ \
#    && rm -f tomcat-connectors-1.2.48-src.tar.gz
#EXPOSE 80
#
## Timezone
#RUN mv /etc/localtime /etc/localtime_org \
#    && ln -s /usr/share/zoneinfo/Asia/Seoul /etc/localtime
#
## Simple startup script to avoid some issues observed with container restart
#ADD run-httpd.sh /run-httpd.sh
#RUN chmod -v +x /run-httpd.sh
#
#CMD ["/run-httpd.sh"]
#

# V2
FROM alpine:3.14
RUN apk add --no-cache apache2 tzdata
ADD /mod_jk.so /usr/lib/apache2
# Timezone
RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
RUN apk del tzdata
ENTRYPOINT ["/usr/sbin/httpd", "-DFOREGROUND"]

#
#FROM alpine:3.14
#
#ENV JK_VERSION="1.2.48"
#
#RUN apk --no-cache upgrade && \
#    apk --no-cache \
#        add apache2 \
#            apache2-ssl \
#            curl \
#            bind-tools && \
#    \
#    apk --no-cache \
#        add --virtual .build-deps \
#            apache2-dev \
#            autoconf \
#            automake \
#            gcc \
#            g++ \
#            libtool \
#            tzdata \
#            make && \
#    \
#    curl -SL https://downloads.apache.org/tomcat/tomcat-connectors/jk/tomcat-connectors-"${JK_VERSION}"-src.tar.gz -o /tmp/tc.tar.gz && \
#    tar zxf /tmp/tc.tar.gz -C /tmp/ && \
#    cd /tmp/tomcat-connectors-"${JK_VERSION}"-src/native && \
#    ./buildconf.sh && \
#    ./configure --with-apxs=/usr/bin/apxs && \
## https://github.com/firesurfing/alpine-mod_jk/blob/master/README.md
#    echo "#include <sys/socket.h>" > /usr/include/sys/socketvar.h && \
#    make && \
#    mv apache-2.0/mod_jk.so /usr/lib/apache2/ && \
#    cd / && \
#    \
#    rm -rf /tmp/tomcat-connectors-"${JK_VERSION}" /tmp/tc.tar.gz
#
#EXPOSE 80
#
## Timezone
#RUN cp /usr/share/zoneinfo/Asia/Seoul /etc/localtime
#
#RUN apk del tzdata
#
#ENTRYPOINT ["/usr/sbin/httpd", "-DFOREGROUND"]