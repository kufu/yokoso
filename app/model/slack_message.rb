# frozen_string_literal: true

# @see
class SlackMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

  # @param dialog_submission [SlackDialogSubmission]
  def self.post_received_message(dialog_submission)
    post_body = new.received_message_post_body(dialog_submission)

    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.chat_postEphemeral(post_body)
  end

  def received_message_post_body(dialog_result)
    { icon_emoji: MESSAGES["intarctive"]["icon"],
      channel: dialog_result.slack_channel_id,
      user: dialog_result.slack_user_id,
      text: MESSAGES["intarctive"]["text_notification"],
      attachments: [
        {
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
      ] }
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
