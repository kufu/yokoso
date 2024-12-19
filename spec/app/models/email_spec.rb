# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/email"

describe Email do
  let!(:slack_id) { "U9999999999" }
  let!(:reception_name) { "株式会社smarthr hoge piyo" }
  let!(:invite_date) { "2024/12/18(Wed) 10:00" }
  let!(:reception_id) { "12345" }
  let!(:email_fixture) do
    <<~EMAIL_BODY
      To:【#{slack_id}】#{reception_name} 様<BR>\r
      <BR>\r
      平素は格別なご高配を賜り、厚く御礼申し上げます。株式会社SmartHRです。<BR>\r
      以下のとおり入館申請を行いました。<BR>\r
      I have registered your admission application as below.<BR>\r
      <BR>\r
      =========================================================<BR>\r
      <BR>\r
      ■　ご来訪日時/Date<BR>\r
      #{invite_date}<BR>\r
      <BR>\r
      ■　ビル/Building<BR>\r
      住友不動産六本木グランドタワー/SUMITOMO FUDOSAN ROPPONGI GRAND TOWER<BR>\r
      東京都港区六本木3-2-1<BR>\r
      <BR>\r
      ■　入館ＩＤ/Guest ID<BR>\r
      #{reception_id}<BR>\r
      <BR>\r
      <BR>\r
    EMAIL_BODY
  end
  context "正常系" do
    let!(:email) { described_class.new(email_fixture) }

    it "slack_id" do
      expect(email.slack_id).to eq slack_id
    end
    it "recept_name" do
      expect(email.recept_name).to eq reception_name
    end
    it "recept_date" do
      expect(email.recept_date).to eq invite_date
    end
    it "recept_id" do
      expect(email.recept_id).to eq reception_id
    end
  end
end
