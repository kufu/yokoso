# frozen_string_literal: true

class Email
  def initialize(params)
    @params = params.gsub("\\n", "").gsub("<BR>", "")
  end

  def slack_id
    @params.match(/(?:To:【)(.+)(?:】)/)[1]
  end

  def recept_name
    @params.match(/(?:】)(.+)(?:\s様)/)[1]
  end

  def recept_date
    @params.match(%r{\d{4}/\d{2}/\d{2}.+\d{2}:\d{2}})[0]
  end

  def recept_id
    @params.match(/Guest ID\r\n(\d+)/)[1]
  end
end
