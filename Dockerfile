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
    mysql-dev \
    nodejs \
    openssh \
    ruby-dev \
    ruby-json \
    tzdata \
    yaml \
    yaml-dev \
    zlib-dev \
    imagemagick \
    jq

RUN gem install bundler

ENV RAILS_ENV=production
ARG RAILS_MASTER_KEY

RUN mkdir /app
WORKDIR /app
ADD Gemfile /app/Gemfile
ADD Gemfile.lock /app/Gemfile.lock

RUN bundle config build.nokogiri --use-system-libraries && \
    bundle config build.mysql2 --use-system-libraries && \
    bundle install --jobs 20 --retry 5

ADD . /app
RUN echo $RAILS_MASTER_KEY > /app/config/secrets.yml.key

EXPOSE 3000

CMD ["bundle", "exec", "rails", "s", "puma", "-b", "0.0.0.0", "-p", "3000", "-e", "${RAILS_ENV}"]
