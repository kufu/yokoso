# frozen_string_literal: true

require "json"
require "slack-ruby-client"
require_relative "..//model/email"

module SlackNotification
  def run(request)
    json = JSON.parse(request.body.read)
    mail_body = json["body"]
    email = Email.new(mail_body)

    client = Slack::Web::Client.new(
      token: ENV.fetch("SLACK_TOKEN")
    )

    messages = open("./config/messages.yml", "r") { |f| YAML.safe_load(f) }

    res = client.chat_postMessage(
      icon_emoji: messages["notification"]["icon"],
      channel: ENV.fetch("SLACK_CHANNEL"),
      text: "<@#{email.slack_id}> #{messages['notification']['text_notification']}",
      attachments: [
        {
          color: "#36a64f",
          fields: [
            {
              title: messages["notification"]["recept_name"],
              value: "#{email.recept_name} 様",
              short: true
            },
            {
              title: messages["notification"]["recept_datetime"],
              value: email.recept_date,
              short: true
            },
            {
              title: messages["notification"]["recept_id"],
              value: email.recept_id,
              short: true
            }
          ]
        }
      ]
    )

    barcode_url = "https://barcode.tec-it.com/barcode.ashx?data=#{email.recept_id}&code=Code128"
    text_guide_jap = messages["notification"]["text_guide_jap"]
    text_guide_eng = messages["notification"]["text_guide_eng"]

    text_guide_jap.gsub!("RECEPT_ID", "#{email.recept_id}\n#{barcode_url}")
    text_guide_eng.gsub!("RECEPT_ID", "#{email.recept_id}\n#{barcode_url}")

    day_of_the_week_eg2jp = {
      "Sun" => "日",
      "Mon" => "月",
      "Tue" => "火",
      "Wed" => "水",
      "Thu" => "木",
      "Fri" => "金",
      "Sat" => "土"
    }
    recept_date_jap = email.recept_date.gsub(/([a-zA-Z]{3})/, day_of_the_week_eg2jp)
    text_guide_jap.gsub!("RECEPT_DATE", "#{recept_date_jap}")
    text_guide_eng.gsub!("RECEPT_DATE", "#{email.recept_date}")

    res = client.chat_postMessage(
      icon_emoji: ":office:",
      channel: res.channel,
      text: "#{text_guide_jap}\n#{text_guide_eng}",
      attachments: [
        {
          title: "バーコード/Barcode",
          image_url: barcode_url
        }
      ],
      thread_ts: res.ts
    )

    return
  end

  module_function :run
end
