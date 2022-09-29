FROM php:7.4-alpine

ARG REVIEWDOG_VERSION=v0.10.0
ARG PHPCS_VERSION=3.7.1
ARG PHPMD_VERSION=2.13.0

RUN wget -O - -q https://raw.githubusercontent.com/reviewdog/reviewdog/master/install.sh| sh -s -- -b /usr/local/bin/ ${REVIEWDOG_VERSION}
RUN wget -P /usr/local/bin -q https://github.com/squizlabs/PHP_CodeSniffer/releases/download/${PHPCS_VERSION}/phpcs.phar \
  && wget -P /usr/local/bin -q https://github.com/phpmd/phpmd/releases/download/${PHPMD_VERSION}/phpmd.phar \
  && chmod +x /usr/local/bin/phpcs.phar \
  && chmod +x /usr/local/bin/phpmd.phar

RUN apk --no-cache add git \
 && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
WORKDIR /tmp
