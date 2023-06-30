FROM nginx:latest

USER root

COPY haproxy.cfg /usr/local/etc/haproxy/haproxy.cfg
COPY takeover.JSON /usr/local/etc/haproxy/takeover.JSON
COPY run.sh /usr/local/etc/haproxy/run.sh

EXPOSE 6633

RUN apt update
RUN apt install -y jq

RUN mkdir -p /run/haproxy
RUN touch /run/haproxy/admin.sock

#CMD ["haproxy", "-f", "/usr/local/etc/haproxy/haproxy.cfg"]
RUN /usr/local/etc/haproxy/run.sh