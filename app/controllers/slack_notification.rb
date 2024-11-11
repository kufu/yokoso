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

    res = AdmissionCodeMessage.new(email).post

    zapier_pdf_url = request["pdf"]
    file_name_prefix = SecureRandom.alphanumeric(10)
    qrcode = QrCodePdf.new(zapier_pdf_url, file_name_prefix)
    qrcode.download
    qrcode.unzip

    ChatMessageSender.new.post_public_message(
      {
        icon_emoji: ":office:",
        channel: email.slack_id,
        text: "入館用QRコードを生成しました",
        as_user: true
      },
      file_paths: qrcode.entry_qr_code_path,
      direct_message_id: res["channel"],
    )

    ""
  end

  module_function :run
end
