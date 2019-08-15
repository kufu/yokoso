require 'sinatra/base'
require_relative './app/controllers/app'

controller = Sinatra.new do
  enable :logging
end

map('/') do
  run Sinatra.new(controller) { get('/') { 'ok' } }
end

map('/app') do
  run Yokoso
end