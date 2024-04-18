FROM ruby:3.1.2


# Install essential packages
RUN apt-get update -qq && \
    apt-get install -y build-essential libvips bash bash-completion tzdata postgresql nodejs npm yarn && \    
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /usr/share/doc /usr/share/man


# Set working directory
WORKDIR /rails

# Set environment variables
ENV RAILS_ENV="development"

# Copy application code
COPY . ./

# Install Ruby dependencies
RUN bundle install

# Initialize npm and install packages
RUN npm init -y && npm install && npm install save stylelint@13.x stylelint-scss@3.x stylelint-config-standard@21.x stylelint-csstree-validator@1.x

# Install Ruby dependencies again (in case Gemfile or Gemfile.lock changed)
RUN bundle  install    

# Run RuboCop and stylelint
RUN  rubocop --auto-correct-all && npx stylelint "**/*.{css,scss}" --fix

# Set entrypoint script
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

# Expose port
EXPOSE 3000

# Default command to start Rails server
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]

 

