FROM ruby:alpine

MAINTAINER Dmitry Ustalov <dmitry.ustalov@gmail.com>

EXPOSE 9292

ENV RACK_ENV=production LANG=en_US.utf8

WORKDIR /home/app/petrovich

COPY . /home/app/petrovich/

RUN \
gem install bundler && \
bundle config git.allow_insecure true && \
apk add --no-cache nodejs && \
apk add --no-cache --virtual .gem-installdeps git build-base openssl-dev && \
bundle install --deployment --without 'development test' --jobs 4 && \
bundle exec rake assets:precompile && \
apk del .gem-installdeps

USER nobody

CMD bundle exec puma -t 1:4
