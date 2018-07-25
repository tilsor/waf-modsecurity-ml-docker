FROM owasp/modsecurity:v2-fedora-apache
MAINTAINER Rodrigo Martinez rm1000@gmail.com

RUN dnf -y update

RUN dnf -y install java

RUN cd /opt && \
  git clone -b master https://gitlab.fing.edu.uy/gsi/modsec-ml.git modsec-ml && \
  cp -R /opt/modsec-ml/ /etc/httpd/modsecurity.d/ml/ && \
  cd /etc/httpd/modsecurity.d && \
  printf "IncludeOptional modsecurity.d/ml/*.conf\n" > include.conf && \
  sed -i -e 's/SecRuleEngine DetectionOnly/SecRuleEngine On/g' /etc/httpd/modsecurity.d/modsecurity.conf

#COPY docker-entrypoint.sh /

EXPOSE 80

#ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["httpd", "-k", "start", "-D", "FOREGROUND"]
