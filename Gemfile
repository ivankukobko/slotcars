source 'https://rubygems.org'

gem 'rails', '3.2.0'
gem 'pg'

gem 'devise' # authentication

gem 'airbrake'
gem 'newrelic_rpm'

gem 'pusher'

# better serialization of models
gem "active_model_serializers", :git => "git://github.com/josevalim/active_model_serializers.git"

group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '>= 1.0.3'
end

gem 'jquery-rails'
gem 'embient', '0.1.0'

group :development, :test do
  # jasmine testing + coffeescript support
  gem 'jasminerice'

  # automatically runs tests in phantomJS
  gem 'guard-jasmine', '1.2.0'

  # for notifications of auto-test results
  gem 'growl'

  # rspec and shoulda for rails testing
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'factory_girl_rails'
end
