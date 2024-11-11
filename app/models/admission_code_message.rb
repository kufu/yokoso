# frozen_string_literal: true

# チャットツールへのメッセージ送信を扱うクラス
class AdmissionCodeMessage
  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoadQ
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.unsafe_load(f) }

  # @param email [Email]
  def initialize(email)
    @email = email
    freeze
  end

  def post
    chat_message_sender = ChatMessageSender.new
    res = chat_message_sender.post_public_message(api_post_body) if send_to_channel?
    res = chat_message_sender.post_public_message(api_post_body_direct_message) if send_to_direct_message?
    res
  end

  private

  def send_to_channel?
    %w[CHANNEL BOTH].include?(ENV.fetch("SEND_MODE"))
  end

  def send_to_direct_message?
    %w[DM BOTH].include?(ENV.fetch("SEND_MODE"))
  end

  # @return [Hash] postMessage API post body
  # @see https://api.slack.com/methods/chat.postMessage
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  # @private
  def api_post_body
    { icon_emoji: MESSAGES["notification"]["icon"],
      channel: ENV.fetch("SLACK_CHANNEL"),
      text: "<@#{@email.slack_id}> #{MESSAGES['notification']['text_notification']}",
      attachments: [
        color: "good",
        fields: attachment_fields
      ],
      as_user: true }
  end

  def api_post_body_direct_message
    { icon_emoji: MESSAGES["notification"]["icon"],
      channel: @email.slack_id,
      text: "<@#{@email.slack_id}> #{MESSAGES['notification']['text_notification']}",
      attachments: [
        color: "good",
        fields: attachment_fields
      ],
      as_user: true }
  end

  # @return [Array] attachment_field array
  # @private
  def attachment_fields
    [
      { title: MESSAGES["notification"]["recept_name"],
        value: "#{@email.recept_name} 様",
        short: true },
      { title: MESSAGES["notification"]["recept_datetime"],
        value: @email.recept_date,
        short: true },
      { title: MESSAGES["notification"]["recept_id"],
        value: @email.recept_id,
        short: true }
    ]
  end
end
