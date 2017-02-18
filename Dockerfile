FROM debian:8

ENV DEBIAN_FRONTEND noninteractive

# Setup Arvados repo and install
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         apt-utils \
         software-properties-common \
    && apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7 \
    && (echo "deb http://apt.arvados.org/ jessie main" | tee /etc/apt/sources.list.d/arvados.list) \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
         libarvados-perl \
         python-arvados-fuse \
         python-arvados-python-client \
         rubygem-arvados-cli \
    && rm -rf /var/lib/apt/lists/*

# Set workdir and entrypoint
WORKDIR /tmp
ENTRYPOINT [/usr/local/bin/arv]
