# frozen_string_literal: true

require "mechanize"
require "sidekiq"
require "slack-ruby-client"
require_relative "../models/slack_modal_submission"
require_relative "../models/slack_message"
require_relative "../../config/initializers/sidekiq"

require "dotenv"
Dotenv.load
class ReceptionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(slack_modal)
    modal_submission = SlackModalSubmission.new(slack_modal)
    # slack modal input
    recept_date = modal_submission.recept_date
    recept_time = modal_submission.recept_time
    recept_company_name = modal_submission.company_name
    recept_visitor_name = modal_submission.visitor_name
    slack_id = modal_submission.slack_user_id

    # srd-gate login
    agent = Mechanize.new
    agent.get("https://srd-gate.com/03/login.cgi")
    agent.page.form.field_with(name: "userid").value = ENV.fetch("SRD_GATE_USERNAME")
    agent.page.form.field_with(name: "passwd").value = ENV.fetch("SRD_GATE_PASSWORD")
    agent.page.form.submit

    # srd-gate regist page
    agent.get("https://srd-gate.com/03/sinsei.cgi")

    # regist parameter
    agent.page.form.field_with(name: "raihoubi").value = recept_date
    agent.page.form.field_with(name: "raihoujikan").value = recept_time
    agent.page.form.checkbox_with(name: "seminarcheck").check # 団体受付可能フラグ
    # slack id を会社名につけて登録結果メールに情報を引回す
    # メール受信 webhook を受け取って、登録者にメンションするため
    # 半角記号は使えない仕様なので削除する
    agent.page.form.field_with(name: "kaisha[]").value = "【#{slack_id}】" + recept_company_name.gsub(/[[:punct:]]/, "")
    agent.page.form.field_with(name: "mei[]").value = recept_visitor_name.gsub(/[[:punct:]]/, "")
    agent.page.form.field_with(name: "kana[]").value = "カナ"
    agent.page.form.field_with(name: "mail[]").value = ENV.fetch("MAIL_ADDRESS_WEBHOOK")
    agent.page.form.field_with(name: "sinseiemail1").value = ENV.fetch("MAIL_ADDRESS_HOST")
    agent.page.form.field_with(name: "sinseitel").value = ENV.fetch("COMPANY_TEL")

    # regist
    agent.page.form.submit

    SlackMessage.post_received_message(modal_submission)
  end
end
