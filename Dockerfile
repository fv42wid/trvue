FROM ruby:2.4.5
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get install -y nodejs postgresql-client

RUN apt-get update && apt-get install -y curl apt-transport-https wget && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d//yarn.list && apt-get update && apt-get install -y yarn

RUN mkdir /trvue
WORKDIR /trvue
COPY Gemfile /trvue/Gemfile
COPY Gemfile.lock /trvue/Gemfile.lock
RUN bundle install
COPY . /trvue

# add a script to be executed every time the container starts
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
CMD entrypoint.sh
EXPOSE 3000

# start the main process
CMD ["rails", "server", "-b", "0.0.0.0"]
