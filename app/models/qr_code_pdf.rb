# frozen_string_literal: true

require "mechanize"
require "zip"

class QrCodePdf
  def initialize(pdf_url, recept_id)
    @pdf_url = pdf_url
    @recept_id = recept_id
    @agent = Mechanize.new
  end

  def download
    @agent.get(@pdf_url).save_as("#{@recept_id}_qr_code.zip")
  end

  def unzip
    dist_path = "#{@recept_id}_qr_code"
    Dir.mkdir(dist_path)
    Zip::File.open("#{@recept_id}_qr_code.zip") do |zip_file|
      zip_file.each do |entry|
        entry.extract("#{dist_path}/#{entry.name}")
      end
    end
  end

  def entry_qr_code_path
    qr_code_path = "#{@recept_id}_qr_code"

    Dir.glob("#{qr_code_path}/Mobile_QR*")
  end
end