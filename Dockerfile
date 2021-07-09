FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

ENV RUBY_VERSION "3.0.2"
ENV RUBY_SHA256 "5085dee0ad9f06996a8acec7ebea4a8735e6fac22f22e2d98c3f2bc3bef7e6f1  ruby-3.0.2.tar.gz"
ENV MAILCATCHER_VERSION "0.7.1"
ENV MAILCATCHER_SHA256 "166037f917109995ef51485df20bddb8dc62543f9fa67412d4a09fed3cf3810b  mailcatcher-0.7.1.gem"

RUN apt-get update -y && \
    apt-get install -y \
                    --no-install-recommends \
                    build-essential \
                    libssl-dev \
                    wget \
                    ruby \
                    autoconf \
                    ca-certificates \
                    libjemalloc-dev \
                    zlib1g-dev \
                    libsqlite3-dev \
                    wget && \
    rm -rf /var/lib/apt/lists/* && \
    \
    mkdir -p /usr/local/etc && \
    { \
      echo 'install: --no-document'; \
      echo 'update: --no-document'; \
    } >> /usr/local/etc/gemrc && \
    \
    cd /tmp && \
    wget -q https://cache.ruby-lang.org/pub/ruby/3.0/ruby-$RUBY_VERSION.tar.gz && \
    tar -xzf ruby-$RUBY_VERSION.tar.gz && \
    echo $RUBY_SHA256 | sha256sum --check && \
    cd ruby-$RUBY_VERSION && \
    autoconf && \
    ./configure --disable-install-doc \
                --disable-install-rdoc \
                --enable-shared \
                --with-jemalloc && \
    make && \
    make install && \
    rm -rf /tmp/ruby-$RUBY_VERSION.tar.gz /tmp/ruby-$RUBY_VERSION && \
    cd /tmp && \
    wget -q https://github.com/sj26/mailcatcher/releases/download/v$MAILCATCHER_VERSION/mailcatcher-$MAILCATCHER_VERSION.gem && \
    echo $MAILCATCHER_SHA256 | sha256sum --check && \
    gem install mailcatcher-$MAILCATCHER_VERSION.gem && \
    rm -rf mailcatcher-$MAILCATCHER_VERSION.gem && \
    groupadd -g 2001 mailcatcher && \
    useradd -m -g mailcatcher -u 2001 mailcatcher && \
    apt-get remove --purge \
                   -y \
                   --allow-remove-essential \
                   wget \
                   autoconf \
                   ruby \
                   ca-certificates \
                   build-essential && \
    apt-get autoremove -y && \
    apt-get clean -y

USER mailcatcher:mailcatcher

ENTRYPOINT ["mailcatcher", "--ip", "0.0.0.0", "--foreground", "--no-quit", "--verbose"]
