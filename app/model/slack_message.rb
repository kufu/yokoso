# frozen_string_literal: true

# @see 
class SlackMessage
  def attachment_field(title:, value:, short: true)
    { title: title,
      value: value,
      short: short }
  end
end
