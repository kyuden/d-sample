FROM ruby:2.4.1-alpine

ENV LANG ja_JP.UTF-8
ENV PAGER busybox less

RUN apk update && \
    apk upgrade && \
    apk add --update\
    bash \
    build-base \
    curl-dev \
    git \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    nodejs \
    openssh \
    ruby-dev \
    ruby-json \
    tzdata \
    yaml \
    yaml-dev \
    zlib-dev

RUN gem install bundler

ENV RAILS_ENV=production
ARG RAILS_MASTER_KEY

RUN mkdir /src
WORKDIR /src
ADD Gemfile /src/Gemfile
ADD Gemfile.lock /src/Gemfile.lock

RUN echo "install: --no-document" > /src/.gemrc && echo "update: --no-document" >> /src/.gemrc
RUN bundle install --path vendor/bundle --jobs 2 && \
    bundle clean

ADD . /src
RUN echo $RAILS_MASTER_KEY > /src/config/secrets.yml.key

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "${RAILS_ENV}"]
