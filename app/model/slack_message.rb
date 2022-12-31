# frozen_string_literal: true

# @see 
class SlackMessage
  # @see https://api.slack.com/reference/messaging/attachments
  def attachments(fields:, color: "good")
    { color: color,
      fields: fields }
  end

  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
