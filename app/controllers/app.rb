# frozen_string_literal: true

require "sinatra/base"
require_relative "./slack_slash_command"
require_relative "./slack_interactive_message"
require_relative "./slack_notification"

class Yokoso < Sinatra::Base
  helpers SlackSlashCommand, SlackInteractiveMessage, SlackNotification

  post("/dialog") do
    SlackSlashCommand.run(request)
  end

  post("/interactive") do
    SlackInteractiveMessage.run(request)
  end

  post("/notification") do
    SlackNotification.run(request)
  end
end
