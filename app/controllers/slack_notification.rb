require 'json'
require 'slack-ruby-client'

module SlackNotification
  def run(request)

    json = JSON.parse(request.body.read)
    mail_body = json['body']
    mail_body = mail_body.gsub("\\n", "")
  
    slack_id = mail_body.match(/(?:To:【)(.+)(?:】)/)[1]
    recept_name = mail_body.match(/(?:】)(.+)(?:\s様)/)[1]
    recept_date = mail_body.match(/\d{4}\/\d{2}\/\d{2}.+\d{2}:\d{2}/)[0]
    recept_id = mail_body.match(/(?:ID:)(\d+)(?:\s+\*)/)[1]

    day_of_the_week_eg2jp = {
      'Sun' => '日',
      'Mon' => '月',
      'Tue' => '火',
      'Wed' => '水',
      'Thu' => '木',
      'Fri' => '金',
      'Sat' => '土',
    }
    recept_date = recept_date.gsub(/([a-zA-Z]{3})/, day_of_the_week_eg2jp)

    client = Slack::Web::Client.new(
      token: ENV['SLACK_TOKEN']
    )

    messages = open('./config/messages.yml', 'r') { |f| YAML.load(f) }
  
    res = client.chat_postMessage(
      icon_emoji: messages['notification']['icon'],
      channel: ENV['SLACK_CHANNEL'],
      text: "<@#{slack_id}> #{messages['notification']['text_notification']}",
      attachments: [
        {
          color: "#36a64f",
          fields: [
            {
              title: messages['notification']['recept_name'],
              value: "#{recept_name} 様",
              short: true
            },
            {
              title: messages['notification']['recept_datetime'],
              value: recept_date,
              short: true
            },
            {
              title: messages['notification']['recept_id'],
              value: recept_id,
              short: true
            }
          ]
        }
      ]
    )

    barcode_url = "https://barcode.tec-it.com/barcode.ashx?data=#{recept_id}&code=Code128"
    text_guide = messages['notification']['text_guide']
    text_guide.gsub!('RECEPT_DATE', "#{recept_date}")
    text_guide.gsub!('RECEPT_ID', "#{recept_id}\n#{barcode_url}")

    res = client.chat_postMessage(
      icon_emoji: ':office:',
      channel: res.channel,
      text: text_guide,
      attachments: [
        {
          title: "バーコード/Barcode",
          image_url: barcode_url,
        }
      ],
      thread_ts: res.ts
    )
    
    return
  end

  module_function :run
end