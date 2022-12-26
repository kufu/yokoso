# frozen_string_literal: true

require "json"
require_relative "../workers/reception_worker"

module SlackInteractiveMessage
  def run(request)
    req = URI.decode_www_form(request.body.read)
    payload = req.assoc("payload").last
    slack_dialog = JSON.parse(payload)

    # Slack のレスポンス3秒以内ルールのため非同期処理
    ReceptionWorker.perform_async slack_dialog
  end

  module_function :run
end
