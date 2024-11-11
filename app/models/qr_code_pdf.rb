# frozen_string_literal: true

require "mechanize"
require "zip"
require "fileutils"

class QrCodePdf
  def initialize(pdf_url, prefix)
    @pdf_url = pdf_url
    @prefix = prefix
    @agent = Mechanize.new
  end

  def download
    @agent.get(@pdf_url).save_as("#{@prefix}_qr_code.zip")
  end

  def unzip
    dist_path = "#{@prefix}_qr_code"
    Dir.mkdir(dist_path)
    Zip::File.open("#{@prefix}_qr_code.zip") do |zip_file|
      zip_file.each do |entry|
        entry.extract("#{dist_path}/#{entry.name}")
      end
    end
  end

  def entry_qr_code_path
    qr_code_path = "#{@prefix}_qr_code"

    Dir.glob("#{qr_code_path}/Mobile_QR*")
  end

  def cleanup
    File.delete("#{@prefix}_qr_code.zip")
    FileUtils.rm_rf("#{@prefix}_qr_code")
  end
end
