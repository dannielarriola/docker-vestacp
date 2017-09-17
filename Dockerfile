FROM ubuntu:16.04

ENV VEMAIL=demo@vestacp.com

ENV VPASS=p4ssword

RUN mkdir /data

VOLUME /data

RUN apt-get update -y \
    && apt-get install -y \
    curl \
    wget \
    lsb-release \
    supervisor

RUN mkdir -p /var/log/supervisor

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

RUN /bin/bash -c "curl -O http://vestacp.com/pub/vst-install.sh"
RUN ["/bin/bash","vst-install.sh", "--email", "$VEMAIL", "--password", "$VPASS", "--proftpd","yes","--vsftpd","no","--hostname","localhost","--interactive","no"]

WORKDIR /usr/local/vesta

ENV VESTA=/usr/local/vesta

EXPOSE 8083

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]