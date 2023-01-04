# frozen_string_literal: true

require "active_support"

# @see https://api.slack.com/dialogs
class SlackDialogSubmission
  # @param post_body [Hash]
  def initialize(post_body)
    @post_body = post_body.deep_symbolize_keys
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

  # @return [String]
  def recept_time
    @post_body.dig(:submission, :time)
  end

  # @return [String]
  def company_name
    @post_body.dig(:submission, :company_name)
  end

  # @return [String]
  def visitor_name
    @post_body.dig(:submission, :name)
  end
end
