FROM mysql:5.6

ENV ENTRYKIT_VERSION=0.4.0
ENV TZ Asia/Tokyo


RUN apt-get update&&apt-get install -y curl&&apt-get install -y dnsutils

RUN curl -sSL https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz | tar zxv \
  && mv entrykit /bin/entrykit && chmod +x /bin/entrykit \
    && entrykit --symlink

RUN rm -f /etc/localtime && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime

COPY my.cnf.tmpl /tmp/my.cnf.tmpl
COPY init.d/ /docker-entrypoint-initdb.d
COPY random.sh /tmp/random.sh
RUN chmod +x /tmp/random.sh
RUN /tmp/random.sh
