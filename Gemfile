# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |_repo_name| "https://github.com/kufu/yokoso" }

ruby File.read(".ruby-version").rstrip

gem "activesupport"
gem "config"
gem "dotenv"
gem "faraday"
gem "mechanize"
gem "rackup"
gem "roda"
gem "rubyzip"
gem "sidekiq"
gem "slack-ruby-client"

group :development do
  gem "byebug"
  gem "guard"
  gem "guard-rspec", require: false
end

group :development, :test do
  gem "hashie"
  gem "pry"
  gem "rspec", "~> 3.13"
  gem "rubocop"
end
