# frozen_string_literal: true

require_relative "../models/slack_dialog"

# @see https://api.slack.com/interactivity/slash-commands
module SlackSlashCommand
  def run(request)
    SlackDialog.open(request["trigger_id"])

    ""
  end

  module_function :run
end
