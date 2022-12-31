# frozen_string_literal: true

require "date"

# @see https://api.slack.com/dialogs
class SlackDialog
  SELECT_DATE_RANGE_NUM   = 90
  SELECT_TIME_HOUR_START  = 8
  SELECT_TIME_HOUR_END    = 21

  # @param label        [String]
  # @param name         [String]
  # @param placeholder  [String]
  # @return [Hash]
  # @see https://api.slack.com/dialogs#dialogs__dialog-form-elements__textarea-elements
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
  def select_element(label:, name:, options:)
    { label: label,
      type: "select",
      name: name,
      options: options }
  end

  # @return [Array]
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
  def time_select_options
    hours = (SELECT_TIME_HOUR_START..SELECT_TIME_HOUR_END).to_a
    hours.map do |hour|
      padded_hours = format("%.2d", hour)
      [{ label: "#{padded_hours}:00", value: "#{padded_hours}:00" },
       { label: "#{padded_hours}:30", value: "#{padded_hours}:30" }]
    end.flatten
  end
end
