source "https://rubygems.org"

gem "rails", "~> 8.0.2"

gem "bootsnap", require: false
gem "importmap-rails"
gem "kamal", require: false
gem "mongoid"
gem "propshaft"
gem "puma", ">= 5.0"
gem "restiny"
gem "stimulus-rails"
gem "thruster", require: false
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[ windows jruby ]

group :development, :test do
  gem "brakeman", require: false
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "rubocop-rails-omakase", require: false
end

group :development do
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
