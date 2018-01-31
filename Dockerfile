FROM ruby:2.5.0-alpine

RUN apk add --update \
  build-base \
  libxml2-dev \
  libxslt-dev \
  libpq \
  postgresql-dev \
  ruby \
  ruby-bundler \
  ruby-rake \
  nodejs \
  && rm -rf /var/cache/apk/*

# Use libxml2, libxslt a packages from alpine for building nokogiri
RUN bundle config build.nokogiri --use-system-libraries
RUN bundle config build.pg --use-system-libraries

RUN mkdir /app
WORKDIR /app

COPY Gemfile /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
COPY package.json /app/package.json
COPY package-lock.json /app/package-lock.json
COPY wait-for-postgres.sh /app/wait-for-postgres.sh

RUN npm install
RUN gem install newrelic_rpm
RUN bundle install

COPY . /app

EXPOSE 3000

CMD ["bundle", "exec", "rails", "server", "--port", "3000"]

LABEL maintainer="Liss McCabe <liss@cuteasheck.com>"
