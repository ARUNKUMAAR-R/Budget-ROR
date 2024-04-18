#!/bin/bash

# Run the necessary commands sequentially
./bin/rails db:create
./bin/rails db:migrate RAILS_ENV=development

# Start the Rails server
exec "$@"

