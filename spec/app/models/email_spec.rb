# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/email"

describe Email do
  context "正常系" do
    email_html_body = <<~EMAIL_BODY
      To:【U9999999999】株式会社smarthr hoge piyo 様<BR>
      <BR>
      平素は格別なご高配を賜り、厚く御礼申し上げます。株式会社SmartHRです。<BR>
      以下のとおり入館申請を行いました。<BR>
      I have registered your admission application as below.<BR>
      =========================================================<BR>
      <BR>
      ■　ご来訪日時/Date<BR>
      2022/03/31(Thu) 18:00<BR>
      <BR>
      ■　ビル/Building<BR>
      住友不動産六本木グランドタワー/SUMITOMO FUDOSAN ROPPONGI GRAND TOWER<BR>
      <BR>
      ■　バーコード/Barcode<BR>
      入館ID/Guest ID:12345678901<BR>
      <BR>
      　　<img src='12345678901.BMP' width='200'><BR>
      <BR>
    EMAIL_BODY

    email = described_class.new(email_html_body)

    it "slack_id" do
      expect(email.slack_id).to eq "U9999999999"
    end
    it "recept_name" do
      expect(email.recept_name).to eq "株式会社smarthr hoge piyo"
    end
    it "recept_date" do
      expect(email.recept_date).to eq "2022/03/31(Thu) 18:00"
    end
    it "recept_id" do
      expect(email.recept_id).to eq "12345678901"
    end
  end
end
