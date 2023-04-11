# frozen_string_literal: true

require_relative "chat_message_sender"

class SlackMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

  # @param dialog_submission [SlackDialogSubmission]
  # @param dialog_submission [Email]
  def initialize(dialog_submission: nil)
    @dialog_submission = dialog_submission
  end

  # Factory Method
  # @param dialog_submission [SlackDialogSubmission]
  def self.post_received_message(dialog_submission)
    post_body = new(dialog_submission: dialog_submission)
                .send(:received_message_post_body)

    ChatMessageSender.new.post_private_message(post_body)
  end

  private

  # @return [Hash] postEphemeral API post body
  # @see https://api.slack.com/methods/chat.postEphemeral
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  # @private
  def received_message_post_body
    { icon_emoji: MESSAGES["intarctive"]["icon"],
      channel: @dialog_submission.slack_channel_id,
      user: @dialog_submission.slack_user_id,
      text: MESSAGES["intarctive"]["text_notification"],
      attachments: [attachment(fields: received_message_attachment_fields)] }
  end

  # @return [Array] attachment_field array
  # @private
  def received_message_attachment_fields
    [
      attachment_field(
        title: MESSAGES["intarctive"]["recept_name"],
        value: "#{@dialog_submission.company_name} #{@dialog_submission.visitor_name} 様"
      ),
      attachment_field(
        title: MESSAGES["intarctive"]["recept_datetime"],
        value: "#{@dialog_submission.recept_date} #{@dialog_submission.recept_time}"
      )
    ]
  end

  # @param fields [Array]  attachment_field
  # @param color  [String] hex color code (eg. #439FE0)
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  # @private
  def attachment(fields:, color: "good")
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
