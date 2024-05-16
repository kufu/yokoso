# frozen_string_literal: true

# チャットツールへのメッセージ送信を扱うクラス
class ChatMessageSender
  def initialize
    @slack_api_client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
  end

  # 全ユーザーに見える形で投稿
  # @param post_body [Hash]
  # @see https://api.slack.com/methods/chat.postMessage
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  def post_public_message(post_body)
    @slack_api_client.chat_postMessage(post_body)
  end

  def post_direct_message(post_body)
    @slack_api_client.chat_postMessage(post_body)
  end

  # 特定のユーザーだけに見える形で投稿
  # @param post_body [Hash]
  # @see https://api.slack.com/methods/chat.postEphemeral
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  def post_private_message(post_body)
    @slack_api_client.chat_postEphemeral(post_body)
  end
end
