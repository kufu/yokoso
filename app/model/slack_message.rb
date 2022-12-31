# frozen_string_literal: true

# @see 
class SlackMessage
  # @param fields [Array]  attachment_field
  # @param color  [String] hex color code (eg. #439FE0)
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  def attachments(fields:, color: "good")
    { color: color,
      fields: fields }
  end

  # @param title [Array]
  # @param value [String]
  # @param short [Boolean]
  # @return [Hash]
  # @see https://api.slack.com/reference/messaging/attachments
  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
