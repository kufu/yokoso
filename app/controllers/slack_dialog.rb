require 'net/http'

module SlackDialog
  def run(request)

    # get slack trigger id from request
    req = URI.decode_www_form(request.body.read)
    trigger_id = req.assoc('trigger_id').last

    # Array: yyyy/mm/dd
    # today, today + 1, today + 90
    today = Date.today
    dates = []
    for i in 0..90 do
      formatted_date = (today + i).strftime('%Y/%m/%d')
      wday = %w(日 月 火 水 木 金 土)[(today + i).wday]
      date = {label: formatted_date + ' ' + wday , value: formatted_date}
      dates.push(date)
    end

    # Array: hh:mm
    # 08:00, 08:30, ... , 21:00, 21:30
    times = []
    for i in 8..21 do
      hour = sprintf("%.2d", i)
      time_on = {label: "#{hour}:00", value: "#{hour}:00"}
      time_half = {label: "#{hour}:30", value: "#{hour}:30"}
      times.push(time_on)
      times.push(time_half)
    end
    
    messages = open('./config/messages.yml', 'r') { |f| YAML.load(f) }

    # dialog form
    dialog = {
      trigger_id: trigger_id,
      dialog: {
        title: messages['dialog']['tilte'],
        callback_id: 'callback_id',
        submit_label: messages['dialog']['submit'],
        elements: [
          {
            label: messages['dialog']['recept_date'],
            type: 'select',
            name: 'date',
            options: dates,
          },
          {
            label: messages['dialog']['recept_time'],
            type: 'select',
            name: 'time',
            options: times,
          },
          {
            label: messages['dialog']['recept_company'],
            type: 'text',
            name: 'company_name',
            placeholder: messages['dialog']['recept_company_placeholder'],
          },
          {
            label: messages['dialog']['recept_name'],
            type: 'text',
            name: 'name',
            placeholder: messages['dialog']['recept_name_placeholder'],
          },
        ]
      }
    }

    uri = URI.parse('https://slack.com/api/dialog.open')
    https = Net::HTTP.new(uri.host, uri.port)
    https.use_ssl = true

    req = Net::HTTP::Post.new(uri.request_uri)
    req["Content-Type"] = "application/json"
    req["Authorization"] = "Bearer #{ENV['SLACK_TOKEN']}"
    req.body = dialog.to_json

    res = https.request(req)

    return "ok"
  end

  module_function :run
end