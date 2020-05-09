FROM ruby:alpine

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

EXPOSE 9292

ENV RACK_ENV=production LANG=en_US.UTF-8

WORKDIR /home/app/petrovich

COPY . /home/app/petrovich/

RUN \
gem install bundler && \
apk add --no-cache tini nodejs && \
apk add --no-cache --virtual .gem-installdeps git build-base openssl-dev && \
bundle config set deployment 'true' && \
bundle config set without 'development test' && \
bundle install --jobs $(nproc) && \
bundle exec rake assets:precompile && \
apk del .gem-installdeps

USER nobody

ENTRYPOINT ["/sbin/tini", "--"]

CMD bundle exec puma -t 1:4
