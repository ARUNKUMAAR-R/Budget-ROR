FROM ruby:3.1.2
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion tzdata postgresql nodejs npm yarn && \    
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man
WORKDIR /rails
ENV RAILS_ENV="development"
COPY Gemfile Gemfile.lock ./
RUN bundle install
COPY . .
RUN npm init -y && npm install && npm install save stylelint@13.x stylelint-scss@3.x stylelint-config-standard@21.x stylelint-csstree-validator@1.x
RUN bundle  install    
RUN  rubocop --auto-correct-all && npx stylelint "**/*.{css,scss}" --fix
ENTRYPOINT ["/rails/bin/docker-entrypoint"]
EXPOSE 3000
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

 

