# frozen_string_literal: true

# チャットツールへのメッセージ送信を扱うクラス

require "faraday"
class ChatMessageSender
  def initialize(direct_message_id: nil)
    @slack_api_client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
  end

  # @param post_body [Hash]
  # @see https://api.slack.com/methods/chat.postMessage
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  def post_public_message(post_body, file_paths: [], direct_message_id: nil)
    file_urls = []
    files = []
    unless file_paths.empty?
      files = file_paths.map do |file_path|
        res = @slack_api_client.files_getUploadURLExternal(
          filename: File.basename(file_path),
          length: File.size(file_path)
        )

        file_urls.push({ url: res.upload_url, file_path: file_path })

        { id: res.file_id, title: File.basename(file_path) }
      end

      file_urls.each do |file_url_and_path|
        conn = Faraday.new(url: file_url_and_path[:url]) do |f|
          f.request :multipart
          f.request :url_encoded
          f.adapter Faraday.default_adapter
        end
        payload = { file: Faraday::UploadIO.new(file_url_and_path[:file_path], "application/pdf") }
        conn.post do |req|
          req.body = payload
        end
      end
    end

    posted_message_response = @slack_api_client.chat_postMessage(post_body)
    return posted_message_response if file_paths.empty?

    @slack_api_client.files_completeUploadExternal(
      files: files.to_json,
      channel_id: direct_message_id,
      thread_ts: posted_message_response["ts"]
    )
  end
end
