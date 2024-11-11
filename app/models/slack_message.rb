# frozen_string_literal: true

require_relative "chat_message_sender"

class SlackMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.unsafe_load(f) }

  # @param modal_submission [SlackModalSubmission]
  def initialize(modal_submission: nil)
    @modal_submission = modal_submission
  end

  # Factory Method
  # @param modal_submission [SlackModalSubmission]
  def self.post_received_message(modal_submission)
    post_body = new(modal_submission:)
                .send(:received_message_post_body)

    ChatMessageSender.new.post_public_message(post_body)
  end

  private

  # @return [Hash] postEphemeral API post body
  # @see https://api.slack.com/methods/chat.postEphemeral
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  # @private
  def received_message_post_body
    { 
      icon_emoji: MESSAGES["interactive"]["icon"],
      channel: @modal_submission.slack_user_id,
      text:,
      attachments: [attachment(fields: received_message_attachment_fields)],
      as_user: true
     }
  end

  def text
    if send_to_direct_message?
      MESSAGES["interactive"]["dm_text_notification"]
    else
      MESSAGES["interactive"]["text_notification"]
    end
  end

  def send_to_channel_message?
    %w[CHANNEL BOTH].include?(ENV.fetch("SEND_MODE"))
  end

  # @private
  # @return [Boolean]
  def send_to_direct_message?
    %w[DM BOTH].include?(ENV.fetch("SEND_MODE"))
  end

  # @return [Array] attachment_field array
  # @private
  def received_message_attachment_fields
    [
      attachment_field(
        title: MESSAGES["interactive"]["recept_name"],
        value: "#{@modal_submission.company_name} #{@modal_submission.visitor_name} 様"
      ),
      attachment_field(
        title: MESSAGES["interactive"]["recept_datetime"],
        value: "#{@modal_submission.recept_date} #{@modal_submission.recept_time}"
      )
    ]
  end

  # @param fields [Array]  attachment_field
  # @param color  [String] hex color code (eg. #439FE0)
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  # @private
  def attachment(fields:, color: "good")
    { color:,
      fields: }
  end

  # @param title [Array]
  # @param value [String]
  # @param short [Boolean]
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  # @private
  def attachment_field(title:, value:, short: true)
    { title:,
      value:,
      short: }
  end
end
