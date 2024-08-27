# frozen_string_literal: true

require "active_support"
require "active_support/core_ext/hash/indifferent_access"

# @see https://api.slack.com/dialogs
class SlackDialogSubmission
  # @param post_body [Hash]
  def initialize(post_body)
    @post_body = post_body.deep_symbolize_keys
    @values = @post_body.dig(:view, :state, :values)
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
    @values[:recept_date][:recept_date][:selected_option][:value]
  end

  # @return [String]
  def recept_time
    @values[:recept_time][:recept_time][:selected_option][:value]
  end

  # @return [String]
  def company_name
    @values[:recept_company][:recept_company][:value]
  end

  # @return [String]
  def visitor_name
    @values[:recept_name][:recept_name][:value]
  end
end
