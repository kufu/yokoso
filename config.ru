# frozen_string_literal: true

# require "sinatra/base"
# require_relative "./app/controllers/app"

# controller = Sinatra.new do
#   enable :logging
# end

# map("/") do
#   run Sinatra.new(controller) { get("/") { "ok" } }
# end

# map("/app") do
#   run Yokoso
# end

require "roda"
require_relative "./app/controllers/slack_slash_command"
require_relative "./app/controllers/slack_interactive_message"
require_relative "./app/controllers/slack_notification"

class App < Roda
  route do |r|
    # GET /hello/world request
    r.post "app/dialog" do
      SlackSlashCommand.run(r.params)
    end
  end
end

run App.freeze.app
