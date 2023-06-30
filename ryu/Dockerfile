FROM python:3.8-slim-buster

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        iproute2 \
        iputils-ping \
        tcpdump \
        && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/osrg/ryu.git && \
    cd ryu && \
    pip install .

EXPOSE 6633 6653 8080

#CMD [ "ryu-manager" ]