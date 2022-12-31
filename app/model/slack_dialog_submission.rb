# frozen_string_literal: true

# @see https://api.slack.com/dialogs
class SlackDialogSubmittion
  def initialize(post_body)
    @post_body = post_body
  end

  # @return [String]
  def slack_user_id
    @post_body.dig(:user, :id)
  end

  # @return [String]
  def slack_channel_id
    @post_body.dig(:channel, :id)
  end

  # @return [String]
  def recept_date
    @post_body.dig(:submission, :date)
  end
end
