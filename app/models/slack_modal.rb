# frozen_string_literal: true

require "date"
require "yaml"

# @see https://api.slack.com/surfaces/modals
class SlackModal
  SELECT_DATE_RANGE_NUM   = 90
  SELECT_TIME_HOUR_START  = 8
  SELECT_TIME_HOUR_END    = 21

  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoad
  MESSAGES = open("./config/messages.yml", "r") { |f| YAML.unsafe_load(f) }

  # Factory Method
  # @param trigger_id [String]
  def self.open(trigger_id)
    post_body = new.send(:post_body)
    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.views_open(trigger_id:, view: post_body)
  end

  private

  # @return [Hash]
  # @private
  def post_body
    {
      type: "modal",
      callback_id: "callback_id",
      title: {
        type: "plain_text",
        text: MESSAGES["dialog"]["tilte"]
      },
      submit: {
        type: "plain_text",
        text: "送信"
      },
      close: {
        type: "plain_text",
        text: "キャンセル"
      },
      blocks: [
        select_element(
          block_id: "recept_date",
          label: MESSAGES["dialog"]["recept_date"],
          options: date_select_options
        ),
        select_element(
          block_id: "recept_time",
          label: MESSAGES["dialog"]["recept_time"],
          options: time_select_options
        ),
        plain_text_element(
          block_id: "recept_company",
          label: MESSAGES["dialog"]["recept_company"],
          placeholder: MESSAGES["dialog"]["recept_company_placeholder"]
        ),
        plain_text_element(
          block_id: "recept_name",
          label: MESSAGES["dialog"]["recept_name"],
          placeholder: MESSAGES["dialog"]["recept_name_placeholder"]
        )
      ]
    }
  end

  # @param block_id     [String]
  # @param label   [String]
  # @param placeholder  [String]
  # @param action_id    [String]
  # @return [Hash]
  # @see https://api.slack.com/reference/block-kit/block-elements#input
  # @private
  def plain_text_element(block_id:, label:, placeholder:, action_id: nil)
    {
      type: "input",
      block_id:,
      element: {
        action_id: action_id || block_id,
        type: "plain_text_input",
        placeholder: {
          type: "plain_text",
          text: placeholder
        }
      },
      label: {
        type: "plain_text",
        text: label
      }
    }
  end

  # @param block_id     [String]
  # @param label   [String]
  # @param options      [Array]
  # @param action_id    [String]
  # @return [Hash]
  # @see https://api.slack.com/reference/block-kit/block-elements#select
  # @private
  def select_element(block_id:, label:, options:, action_id: nil)
    {
      type: "input",
      block_id:,
      element: {
        type: "static_select",
        action_id: action_id || block_id,
        options:
      },
      label: {
        type: "plain_text",
        text: label
      }
    }
  end

  # @return [Array]
  # @private
  def date_select_options
    dates = (Date.today...(Date.today + SELECT_DATE_RANGE_NUM)).to_a
    dates.map do |date|
      date_text = date.strftime("%Y/%m/%d")
      wday = %w[日 月 火 水 木 金 土][date.wday]
      { text: {
          type: "plain_text",
          text: "#{date_text} #{wday}"
        },
        value: date_text }
    end
  end

  # @return [Array]
  # @private
  def time_select_options
    hours = (SELECT_TIME_HOUR_START..SELECT_TIME_HOUR_END).to_a
    hours.map do |hour|
      padded_hours = format("%.2d", hour)
      [{ text: { type: "plain_text", text: "#{padded_hours}:00" }, value: "#{padded_hours}:00" },
       { text: { type: "plain_text", text: "#{padded_hours}:30" }, value: "#{padded_hours}:30" }]
    end.flatten
  end
end
