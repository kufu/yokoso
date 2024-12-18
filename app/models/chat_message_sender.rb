# frozen_string_literal: true

# チャットツールへのメッセージ送信を扱うクラス

require "faraday"
class ChatMessageSender
  def initialize(direct_message_id: nil)
    @slack_api_client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    @direct_message_id = direct_message_id
  end

  # @param post_body [Hash]
  # @see https://api.slack.com/methods/chat.postMessage
  # @see https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/chat.rb
  def post_public_message(post_body)
    @slack_api_client.chat_postMessage(post_body)
  end

  def post_admission_badge_message(post_body, file_paths: [])
    if file_paths.empty?
      post_body = {
        icon_emoji: ":office:",
        channel: @direct_message_id,
        text: "入館証の発行に失敗しました",
        as_user: true
      }
      @slack_api_client.chat_postMessage(post_body)

      raise "File Path is empty. Check Zapier Settings."
    end

    files = upload_files(file_paths: file_paths)
    posted_message_response = @slack_api_client.chat_postMessage(post_body)
    return posted_message_response if file_paths.empty?

    @slack_api_client.files_completeUploadExternal(
      files: files.to_json,
      channel_id: @direct_message_id,
      thread_ts: posted_message_response["ts"]
    )
  end

  private

  def upload_files(file_paths:)
    file_upload_metadata(file_paths: file_paths).map do |metadata|
      conn = Faraday.new(url: metadata[:url]) do |f|
        f.request :multipart
        f.request :url_encoded
        f.adapter Faraday.default_adapter
      end
      payload = { file: Faraday::UploadIO.new(metadata[:file_path], "application/pdf") }
      conn.post do |req|
        req.body = payload
      end

      { id: metadata[:id], title: metadata[:title] }
    end
  end

  def file_upload_metadata(file_paths:)
    file_paths.map do |file_path|
      res = @slack_api_client.files_getUploadURLExternal(
        filename: File.basename(file_path),
        length: File.size(file_path)
      )
      { id: res.file_id, title: File.basename(file_path), url: res.upload_url, file_path: file_path }
    end
  end
end
