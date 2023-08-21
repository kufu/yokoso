# frozen_string_literal: true

require "json"
require "slack-ruby-client"
require_relative "../models/email"
require_relative "../models/chat_message_sender"
require_relative "../models/admission_code_message"

module SlackNotification
  def run(request)
    mail_body = request["body"]
    email = Email.new(mail_body)

    # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
    messages = open("./config/messages.yml", "r") { |f| YAML.unsafe_load(f) } # rubocop:disable Security/YAMLLoad

    res = AdmissionCodeMessage.new(email).post

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
    text_guide_jap.gsub!("RECEPT_DATE", recept_date_jap)
    text_guide_eng.gsub!("RECEPT_DATE", email.recept_date)

    ChatMessageSender.new.post_public_message(
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

    ""
  end

  module_function :run
end
