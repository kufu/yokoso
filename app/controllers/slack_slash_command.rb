# frozen_string_literal: true

require "net/http"
require_relative "../model/slack_dialog"

module SlackSlashCommand
  def run(request)
    # get slack trigger id from request
    req = URI.decode_www_form(request.body.read)
    trigger_id = req.assoc("trigger_id").last

    # https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/dialog.rb
    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.dialog_open(SlackDialog.post_body(trigger_id))
  end

  module_function :run
end
