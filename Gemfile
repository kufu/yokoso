# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |_repo_name| "https://github.com/kufu/yokoso" }

ruby File.read(".ruby-version").rstrip

gem "activesupport"
gem "config"
gem "faraday"
gem "mechanize"
gem "rackup"
gem "roda"
gem "sidekiq"
gem "slack-ruby-client"
gem "rubyzip"

group :development do
  gem "byebug"
  gem "guard"
  gem "guard-rspec", require: false
end

group :development, :test do
  gem "rspec", "~> 3.12"
  gem "rubocop"
  gem "pry"
end
