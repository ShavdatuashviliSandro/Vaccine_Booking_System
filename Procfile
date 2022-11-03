release: bin/rails db:migrate
web: bin/rails server -p #{port:-5000} -e $RAILS_ENV
worker: sidekiq

web:node index.js