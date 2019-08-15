require 'sinatra/base'

controller = Sinatra.new do
  enable :logging
end

map('/') do
  run Sinatra.new(controller) { get('/') { 'ok' } }
end
