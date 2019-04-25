FROM ruby:2.6.3-alpine3.9
RUN apk add --no-cache git curl libarchive-tools coreutils bash
COPY docker-entrypoint.sh /
COPY 1-extract.sh /
COPY 2-cleanup.rb /
RUN git clone --depth 1 --branch source https://github.com/lepsipraha7/ruian.git /source
ENTRYPOINT ["/docker-entrypoint.sh"]
