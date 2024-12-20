# frozen_string_literal: true

require "json"
require "slack-ruby-client"
require_relative "../models/email"
require_relative "../models/chat_message_sender"
require_relative "../models/admission_code_message"
require_relative "../models/qr_code_pdf"

require "securerandom"

module SlackNotification
  def run(request)
    mail_body = request["body"]
    email = Email.new(mail_body)

    messages = open("./config/messages.yml", "r") { |f| YAML.unsafe_load(f) }

    res = AdmissionCodeMessage.new(email).post

    text_guide_jap = messages["notification"]["text_guide_jap"]
    text_guide_eng = messages["notification"]["text_guide_eng"]

    text_guide_jap.gsub!("RECEPT_ID", email.recept_id.to_s)
    text_guide_eng.gsub!("RECEPT_ID", email.recept_id.to_s)

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

    zapier_pdf_url = request["pdf"]
    file_name_prefix = SecureRandom.alphanumeric(10)
    qrcode = QrCodePdf.new(zapier_pdf_url, file_name_prefix)
    qrcode.download
    qrcode.unzip

    ChatMessageSender.new(direct_message_id: res["channel"]).post_admission_badge_message(
      {
        icon_emoji: ":office:",
        channel: email.slack_id,
        text: "#{text_guide_jap}\n#{text_guide_eng}",
        as_user: true
      },
      file_paths: qrcode.entry_qr_code_path
    )

    qrcode.cleanup

    ""
  end

  module_function :run
end
