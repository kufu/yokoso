# frozen_string_literal: true

# @see 
class SlackMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

  def initialize
    @client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
  end

  def self.post_received_message(submit_payload)
    new.post_received_message(submit_payload)
  end

  def post_received_message(dialog_result)
    @client.chat_postEphemeral(
      icon_emoji: MESSAGES["intarctive"]["icon"],
      channel: dialog_result.slack_channel_id,
      user: dialog_result.slack_user_id,
      text: MESSAGES["intarctive"]["text_notification"],
      attachments: [
        {
          color: "#439FE0",
          fields: [
            {
              title: MESSAGES["intarctive"]["recept_name"],
              value: "#{dialog_result.company_name} #{dialog_result.visitor_name} 様",
              short: true
            },
            {
              title: MESSAGES["intarctive"]["recept_datetime"],
              value: "#{dialog_result.recept_date} #{dialog_result.recept_time}",
              short: true
            }
          ]
        }
      ]
    )
  end

  # @param fields [Array]  attachment_field
  # @param color  [String] hex color code (eg. #439FE0)
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  def attachments(fields:, color: "good")
    { color: color,
      fields: fields }
  end

  # @param title [Array]
  # @param value [String]
  # @param short [Boolean]
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
