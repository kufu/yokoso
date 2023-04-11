# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/email"
require_relative "../../../app/models/admission_code_message"

describe AdmissionCodeMessage do
  let(:instance) { described_class.new(email) }
  let(:email) { Email.new(email_fixture) }
  let!(:email_fixture) do
    <<~EMAIL_BODY
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
  end

  describe "#notification_message_post_body" do
    before do
      allow(ENV).to receive(:fetch).with("SLACK_CHANNEL").and_return("CH15TJXEX")
    end
    it "API post body が返ってくる" do
      expected = {
        icon_emoji: ":office:",
        channel: "CH15TJXEX",
        text: "<@U9999999999> 入館受付が完了しました :tada:",
        attachments: [{
          color: "good",
          fields: instance.send(:notification_message_attachment_fields)
        }]
      }
      expect(instance.send(:notification_message_post_body)).to eq expected
    end
  end
  describe "#notification_message_attachment_fields" do
    it "アタッチメント Array が返ってくる" do
      expected = [
        { title: "来訪者名",
          value: "株式会社smarthr hoge piyo 様",
          short: true },
        { title: "訪問日時",
          value: "2022/03/31(Thu) 18:00",
          short: true },
        { title: "入館ID",
          value: "12345678901",
          short: true }
      ]
      expect(instance.send(:notification_message_attachment_fields)).to eq expected
    end
  end
end
