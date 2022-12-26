# frozen_string_literal: true

require "sinatra/base"
require_relative "./slack_dialog"
require_relative "./slack_interactive_message"
require_relative "./slack_notification"

class Yokoso < Sinatra::Base
  helpers SlackDialog, SlackInteractiveMessage, SlackNotification

  post("/dialog") do
    SlackDialog.run(request)
  end

  post("/interactive") do
    SlackInteractiveMessage.run(request)
  end

  post("/notification") do
    SlackNotification.run(request)
  end
end
