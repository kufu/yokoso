# frozen_string_literal: true

class SlackModal
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
end
