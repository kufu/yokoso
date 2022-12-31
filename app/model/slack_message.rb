# frozen_string_literal: true

# @see 
class SlackMessage
  def attachments(color:, fields:)
    { color: color,
      fields: fields }
  end

  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
