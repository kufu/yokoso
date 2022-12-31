# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) { |_repo_name| "https://github.com/kufu/yokoso" }

ruby File.read(".ruby-version").rstrip

gem "config"
gem "http"
gem "mechanize"
gem "nokogiri", ">= 1.10.4"
gem "rack-unreloader"
gem "sidekiq"
gem "sinatra"
gem "sinatra-contrib"
gem "slack-ruby-client"

group :development do
  gem "guard"
  gem "guard-rspec", require: false
end

group :development, :test do
  gem "rspec", "~> 3.12"
  gem "rubocop"
end
