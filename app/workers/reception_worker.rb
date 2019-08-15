require 'mechanize'
require 'sidekiq'
require 'slack-ruby-client'

class ReceptionWorker
  include Sidekiq::Worker
  sidekiq_options queue: :default, retry: false

  def perform(slack_dialog)

    # slack dialog input
    recept_date = slack_dialog['submission']['date']
    recept_time = slack_dialog['submission']['time']
    recept_company_name = slack_dialog['submission']['company_name']
    recept_visitor_name = slack_dialog['submission']['name']
    slack_id = slack_dialog['user']['id']
    slack_channel = slack_dialog['channel']['id']

    # srd-gate login
    agent = Mechanize.new
    page = agent.get("https://srd-gate.com/03/login.cgi")
    agent.page.form.field_with(name: 'userid').value = ENV['SRD_GATE_USERNAME']
    agent.page.form.field_with(name: 'passwd').value = ENV['SRD_GATE_PASSWORD']
    page = agent.page.form.submit
  
    # srd-gate regist page
    page = agent.get("https://srd-gate.com/03/sinsei.cgi")

    # regist parameter
    agent.page.form.field_with(name: 'raihoubi').value = recept_date
    agent.page.form.field_with(name: 'raihoujikan').value = recept_time
    agent.page.form.checkbox_with(name: 'seminarcheck').check # 団体受付可能フラグ
    # slack id を会社名につけて登録結果メールに情報を引回す
    # メール受信 webhook を受け取って、登録者にメンションするため
    # 半角記号は使えない仕様なので削除する
    agent.page.form.field_with(name: 'kaisha[]').value = '【' + slack_id + '】' + recept_company_name.gsub(/[[:punct:]]/, "")
    agent.page.form.field_with(name: 'mei[]').value = recept_visitor_name.gsub(/[[:punct:]]/, "")
    agent.page.form.field_with(name: 'kana[]').value = "カナ"
    agent.page.form.field_with(name: 'mail[]').value = ENV['MAIL_ADDRESS_WEBHOOK']
    agent.page.form.field_with(name: 'sinseiemail').value = ENV['MAIL_ADDRESS_HOST']
    agent.page.form.field_with(name: 'sinseitel').value = ENV['COMPANY_TEL']
  
    # regist
    page = agent.page.form.submit

    client = Slack::Web::Client.new(
      token: ENV['SLACK_TOKEN']
    )

    messages = open('./config/messages.yml', 'r') { |f| YAML.load(f) }

    client.chat_postEphemeral(
      icon_emoji: messages['intarctive']['icon'],
      channel: slack_channel,
      user: slack_id,
      text: messages['intarctive']['text_notification'],
      attachments: [
        {
          color: "#439FE0",
          fields: [
            {
              title: messages['intarctive']['recept_name'],
              value: "#{recept_company_name} #{recept_visitor_name} 様",
              short: true
            },
            {
              title: messages['intarctive']['recept_datetime'],
              value: "#{recept_date} #{recept_time}" ,
              short: true
            },
          ]
        }
      ]
    )

  end
end