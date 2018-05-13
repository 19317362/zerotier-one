ARG BUILD_FROM=amd64/debian:stretch
FROM $BUILD_FROM

ARG ZT_ARCH=amd64
ENV ZT_VERSION 1.2.8

# Install ZeroTier One
RUN apt-get update -yqq \
  && apt-get install curl -y \
  && curl https://download.zerotier.com/debian/stretch/pool/main/z/zerotier-one/zerotier-one_${ZT_VERSION}_${ZT_ARCH}.deb -o /tmp/zerotier-one.deb \
  && dpkg-deb -x /tmp/zerotier-one.deb /tmp/zerotier-one \
  && cp /tmp/zerotier-one/usr/sbin/zerotier-one /usr/bin \
  && ln -s /usr/bin/zerotier-one /usr/bin/zerotier-cli \
  && addgroup --system --gid 1000 zerotier-one \
  && adduser --system --ingroup zerotier-one --home /var/lib/zerotier-one --no-create-home --uid 1000 zerotier-one \
  && mkdir -p /var/lib/zerotier-one/networks.d \
  && rm -rf /tmp/*

VOLUME /var/lib/zerotier-one

COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/docker-entrypoint.sh

WORKDIR /var/lib/zerotier-one

ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 9993
CMD ["zerotier-one","-U","-p9993"]