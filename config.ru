# frozen_string_literal: true

require "roda"
require_relative "./app/controllers/slack_slash_command"
require_relative "./app/controllers/slack_interactive_message"
require_relative "./app/controllers/slack_notification"

class App < Roda
  route do |r|
    r.post "app/dialog" do
      SlackSlashCommand.run(r.params)
    end
    r.post "app/interactive" do
      SlackInteractiveMessage.run(r.params)
    end
    r.post "app/notification" do
      SlackNotification.run(JSON.parse(r.body.read))
    end
  end
end

run App.freeze.app
