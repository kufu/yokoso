# frozen_string_literal: true

require "net/http"

module SlackDialog
  def run(request)
    # get slack trigger id from request
    req = URI.decode_www_form(request.body.read)
    trigger_id = req.assoc("trigger_id").last

    # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoad
    messages = open("./config/messages.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

    # dialog form
    slack_dialog = SlackDialog.new
    dialog = {
      trigger_id: trigger_id,
      dialog: {
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
    }

    uri = URI.parse("https://slack.com/api/dialog.open")
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer #{ENV.fetch('SLACK_TOKEN')}"
    req.body = dialog.to_json

    https.request(req)
  end

  module_function :run
end
