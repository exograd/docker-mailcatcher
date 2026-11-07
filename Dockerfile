# syntax=docker/dockerfile:1.4

FROM alpine:3.24

ENV LANG en_US.utf8

RUN <<EOF
    set -eu

    apk --no-cache add ruby openssl sqlite-libs libstdc++
    apk --no-cache --virtual mailcatcher-build add \
      curl build-base ruby-dev openssl-dev sqlite-dev

    gem install net-smtp

    version=0.10.0
    gem_file=mailcatcher-$version.gem
    gem_repository=https://github.com/sj26/mailcatcher
    gem_uri=$gem_repository/releases/download/v$version/$gem_file
    checksum=f59b6fe184687bdad2b3a4532b79bb331b35830f1d0dccf20750de4663d5030d

    cd /tmp
    curl -sSfL -o $gem_file $gem_uri
    echo "$checksum  $gem_file" | sha256sum -c
    gem install $gem_file
    rm $gem_file
    cd -

    apk del mailcatcher-build

    addgroup -S mailcatcher
    adduser -G mailcatcher -g Mailcatcher -H -D mailcatcher
EOF

USER mailcatcher:mailcatcher

EXPOSE 1025/TCP 1080/TCP

CMD ["mailcatcher", "--ip", "0.0.0.0", "--foreground", "--no-quit"]
