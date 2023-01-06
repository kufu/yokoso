# frozen_string_literal: true

require "net/http"
require_relative "../models/slack_dialog"

# @see https://api.slack.com/interactivity/slash-commands
module SlackSlashCommand
  def run(request)
    req = URI.decode_www_form(request.body.read)
    trigger_id = req.assoc("trigger_id").last

    SlackDialog.open(trigger_id)
  end

  module_function :run
end
