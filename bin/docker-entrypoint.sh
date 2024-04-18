#!/bin/bash

# If running the rails server then create or migrate existing database
if [ "${*}" == "./bin/rails server -b 0.0.0.0 -p 3000" ]; then
  ./bin/rails db:create &&
  ./bin/rails db:migrate  
fi

exec "${@}"
