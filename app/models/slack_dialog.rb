# frozen_string_literal: true

require "date"
require "yaml"

# @see https://api.slack.com/dialogs
class SlackDialog
  SELECT_DATE_RANGE_NUM   = 90
  SELECT_TIME_HOUR_START  = 8
  SELECT_TIME_HOUR_END    = 21

  # TODO: fix Ruby 3.1+ https://www.rubydoc.info/gems/rubocop/RuboCop/Cop/Security/YAMLLoad
  MESSAGES = open("./config/MESSAGES.yml", "r") { |f| YAML.load(f) } # rubocop:disable Security/YAMLLoad

  # Factory Method
  # @param trigger_id [String]
  def self.open(trigger_id)
    post_body = new.send(:post_body, trigger_id)

    # https://github.com/slack-ruby/slack-ruby-client/blob/master/lib/slack/web/api/endpoints/dialog.rb
    client = Slack::Web::Client.new(token: ENV.fetch("SLACK_TOKEN"))
    client.dialog_open(post_body)
  end

  private

  # @param trigger_id [String]
  # @return [Hash]
  # @private
  def post_body(trigger_id)
    { trigger_id: trigger_id,
      dialog: {
        title: MESSAGES["dialog"]["tilte"],
        callback_id: "callback_id",
        submit_label: MESSAGES["dialog"]["submit"],
        elements: [
          select_element(
            label: MESSAGES["dialog"]["recept_date"],
            name: "date",
            options: date_select_options
          ),
          select_element(
            label: MESSAGES["dialog"]["recept_time"],
            name: "time",
            options: time_select_options
          ),
          textarea_element(
            label: MESSAGES["dialog"]["recept_company"],
            name: "company_name",
            placeholder: MESSAGES["dialog"]["recept_company_placeholder"]
          ),
          textarea_element(
            label: MESSAGES["dialog"]["recept_name"],
            name: "name",
            placeholder: MESSAGES["dialog"]["recept_name_placeholder"]
          )
        ]
      } }
  end

  # @param label        [String]
  # @param name         [String]
  # @param placeholder  [String]
  # @return [Hash]
  # @see https://api.slack.com/dialogs#dialogs__dialog-form-elements__textarea-elements
  # @pprivate
  def textarea_element(label:, name:, placeholder:)
    { label: label,
      type: "text",
      name: name,
      placeholder: placeholder }
  end

  # @param label    [String]
  # @param name     [String]
  # @param options  [Array]
  # @return [Hash]
  # @see https://api.slack.com/dialogs#select_elements
  # @pprivate
  def select_element(label:, name:, options:)
    { label: label,
      type: "select",
      name: name,
      options: options }
  end

  # @return [Array]
  # @pprivate
  def date_select_options
    dates = (Date.today...(Date.today + SELECT_DATE_RANGE_NUM)).to_a
    dates.map do |date|
      date_text = date.strftime("%Y/%m/%d")
      wday = %w[日 月 火 水 木 金 土][date.wday]

      { label: "#{date_text} #{wday}",
        value: date_text }
    end
  end

  # @return [Array]
  # @pprivate
  def time_select_options
    hours = (SELECT_TIME_HOUR_START..SELECT_TIME_HOUR_END).to_a
    hours.map do |hour|
      padded_hours = format("%.2d", hour)
      [{ label: "#{padded_hours}:00", value: "#{padded_hours}:00" },
       { label: "#{padded_hours}:30", value: "#{padded_hours}:30" }]
    end.flatten
  end
end
