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
end
