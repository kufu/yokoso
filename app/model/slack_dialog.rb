# frozen_string_literal: true

# @see https://api.slack.com/dialogs
class SlackDialog
  private

  def time_texts
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
end
