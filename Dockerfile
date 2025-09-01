FROM ruby:3-alpine

EXPOSE 9292

ENV BUNDLE_DISABLE_VERSION_CHECK=1 BUNDLE_VERSION=system LANG=en_US.UTF-8 RACK_ENV=production RUBYGEMS_PREVENT_UPDATE_SUGGESTION=1 RUBYOPT="--disable-did_you_mean"

WORKDIR /home/app/petrovich

COPY . /home/app/petrovich/

RUN \
gem install bundler && \
apk add --no-cache libffi nodejs tini && \
apk add --no-cache --virtual .gem-installdeps build-base git libffi-dev openssl-dev && \
bundle config set deployment 'true' && \
bundle config set without 'development test' && \
bundle install --jobs $(nproc) && \
bundle exec rake assets:precompile && \
apk del .gem-installdeps

USER nobody

ENTRYPOINT ["/sbin/tini", "--"]

CMD bundle exec puma -t 1:4
