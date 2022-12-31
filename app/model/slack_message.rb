# frozen_string_literal: true

# @see
class SlackMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

  # Factory Method
  # @param dialog_submission [SlackDialogSubmission]
  def self.post_received_message(dialog_submission)
    post_body = new.received_message_post_body(dialog_submission)

    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.chat_postEphemeral(post_body)
  end

  # @param dialog_submission [SlackDialogSubmission]
  # @return [Hash]
  def received_message_post_body(dialog_submission)
    { icon_emoji: MESSAGES["intarctive"]["icon"],
      channel: dialog_submission.slack_channel_id,
      user: dialog_submission.slack_user_id,
      text: MESSAGES["intarctive"]["text_notification"],
      attachments: [
        attachments(fields: received_message_attachment_fields(dialog_submission))
      ] }
  end

  private

  # @param dialog_submission [SlackDialogSubmission]
  # @return [Array] attachment_field array
  # @private
  def received_message_attachment_fields(dialog_submission)
    [
      attachment_field(
        title: MESSAGES["intarctive"]["recept_name"],
        value: "#{dialog_submission.company_name} #{dialog_submission.visitor_name} 様"
      ),
      attachment_field(
        title: MESSAGES["intarctive"]["recept_datetime"],
        value: "#{dialog_submission.recept_date} #{dialog_submission.recept_time}"
      )
    ]
  end

  # @param fields [Array]  attachment_field
  # @param color  [String] hex color code (eg. #439FE0)
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  # @private
  def attachments(fields:, color: "good")
    { color: color,
      fields: fields }
  end

  # @param title [Array]
  # @param value [String]
  # @param short [Boolean]
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  # @private
  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
