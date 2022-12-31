# frozen_string_literal: true

require "net/http"
require_relative "../model/slack_dialog"

module SlackDialog
  def run(request)
    # get slack trigger id from request
    req = URI.decode_www_form(request.body.read)
    trigger_id = req.assoc("trigger_id").last

    messages = open("./config/MESSAGES.yml", "r") { |f| YAML.load(f) }

    # dialog form
    slack_dialog = SlackDialog.new
    dialog = {
      title: messages["dialog"]["tilte"],
      callback_id: "callback_id",
      submit_label: messages["dialog"]["submit"],
      elements: [
        slack_dialog.select_element(
          label: messages["dialog"]["recept_date"],
          name: "date",
          options: slack_dialog.date_select_options
        ),
        slack_dialog.select_element(
          label: messages["dialog"]["recept_time"],
          name: "time",
          options: slack_dialog.time_select_options
        ),
        slack_dialog.textarea_element(
          label: messages["dialog"]["recept_company"],
          name: "company_name",
          placeholder: messages["dialog"]["recept_company_placeholder"]
        ),
        slack_dialog.textarea_element(
          label: messages["dialog"]["recept_name"],
          name: "name",
          placeholder: messages["dialog"]["recept_name_placeholder"]
        )
      ]
    }

    # https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/dialog.rb
    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.dialog_open(trigger_id: trigger_id,
                       dialog: dialog)
  end

  module_function :run
end
