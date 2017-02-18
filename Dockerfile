FROM debian:8

ENV DEBIAN_FRONTEND noninteractive

# Setup Arvados repo and install prereqs
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
         apt-utils \
         software-properties-common \
         bison \
         build-essential \
         curl \
         gettext \
         libcurl3 \
         libcurl3-gnutls \
         libcurl4-openssl-dev \
         libpcre3-dev \
         libreadline-dev \
         libssl-dev \
         libxslt1.1 \
         zlib1g-dev \
    && apt-key adv --keyserver pool.sks-keyservers.net --recv 1078ECD7 \
    && (echo "deb http://apt.arvados.org/ jessie main" | tee /etc/apt/sources.list.d/arvados.list) \
    && rm -rf /var/lib/apt/lists/*

# Build and install ruby and install arvados-cli gem
RUN mkdir -p /tmp/rubysrc \
    && cd /tmp/rubysrc \
    && (curl -f http://cache.ruby-lang.org/pub/ruby/2.3/ruby-2.3.3.tar.gz | tar xz) \
    && cd ruby-2.3.3 \
    && ./configure --disable-install-rdoc \
    && make \
    && make install \
    && gem install bundler \
    && cd /tmp \
    && rm -rf /tmp/rubysrc \
    && gem install arvados-cli

# Install arvados clients
RUN apt-get update \
    && apt-get install -y \
         libarvados-perl \
         python-arvados-fuse \
         python-arvados-python-client \
    && rm -rf /var/lib/apt/lists/*

# Install docker
RUN (curl -fsSL https://apt.dockerproject.org/gpg | apt-key add -) \
    && add-apt-repository \
       "deb https://apt.dockerproject.org/repo/ \
       debian-$(lsb_release -cs) \
       main" \
    && apt-get update \
    && apt-get -y install docker-engine=1.9.1 \
    && rm -rf /var/lib/apt/lists/*

# Set workdir and entrypoint
WORKDIR /tmp
ENTRYPOINT ["/usr/local/bin/arv"]
