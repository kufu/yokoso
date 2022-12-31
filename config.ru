# frozen_string_literal: true

require "rack/unreloader"
require "sinatra/base"
require_relative "./app/controllers/app"

Unreloader = Rack::Unreloader.new { Yokoso }
Unreloader.require "./app"

controller = Sinatra.new do
  enable :logging
end

map("/") do
  run Sinatra.new(controller) { get("/") { "ok" } }
end

map("/app") do
  run Unreloader # FIXME: 開発が終わったら元に戻す
end
