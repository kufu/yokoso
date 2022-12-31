# frozen_string_literal: true

require 'date'

# @see https://api.slack.com/dialogs
class SlackDialog
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

  def date_select_options
    # Array: hh:mm
    # 08:00, 08:30, ... , 21:00, 21:30
    today = Date.today
    dates = []
    90.times do |i|
      formatted_date = (today + i).strftime("%Y/%m/%d")
      wday = %w[日 月 火 水 木 金 土][(today + i).wday]
      date = { label: "#{formatted_date} #{wday}", value: formatted_date }
      dates.push(date)
    end

    dates
  end

  def time_select_options
    # Array: hh:mm
    # 08:00, 08:30, ... , 21:00, 21:30
    times = []
    (8..21).each do |i|
      hour = format("%.2d", i)
      time_on = { label: "#{hour}:00", value: "#{hour}:00" }
      time_half = { label: "#{hour}:30", value: "#{hour}:30" }
      times.push(time_on)
      times.push(time_half)
    end
    times
  end
end
