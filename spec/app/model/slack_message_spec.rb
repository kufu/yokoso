# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/email"
require_relative "../../../app/model/slack_dialog_submission"
require_relative "../../../app/model/slack_message"

describe SlackMessage do
  let(:instance) { described_class.new }

  describe "#received_message_post_body" do
    context "ok" do
      it do
        modal_submit_fixture = { type: "dialog_submission",
                                 user: { id: "UCKTXCBRB" },
                                 channel: { id: "CH15TJXEX" },
                                 submission: { date: "2023/01/01",
                                               time: "08:00",
                                               company_name: "SmartHR",
                                               name: "須磨 英知" } }
        dialog_submission = SlackDialogSubmission.new(modal_submit_fixture)
        instance = described_class.new(dialog_submission: dialog_submission)

        expected = {
          channel: "CH15TJXEX",
          icon_emoji: ":office:",
          text: "以下の内容で受け付けました。受け付け完了までしばらくお待ちください :pray:",
          user: "UCKTXCBRB",
          attachments: [{
            color: "good",
            fields: [
              { short: true, title: "来訪者名", value: "SmartHR 須磨 英知 様" },
              { short: true, title: "訪問日時", value: "2023/01/01 08:00" }
            ]
          }]
        }
        expect(instance.send(:received_message_post_body)).to eq expected
      end
    end
  end
  describe "#received_message_attachment_fields" do
    context "ok" do
      it do
        modal_submit_fixture = { type: "dialog_submission",
                                 user: { id: "UCKTXCBRB" },
                                 channel: { id: "CH15TJXEX" },
                                 submission: { date: "2023/01/01",
                                               time: "08:00",
                                               company_name: "SmartHR",
                                               name: "須磨 英知" } }
        dialog_submission = SlackDialogSubmission.new(modal_submit_fixture)
        instance = described_class.new(dialog_submission: dialog_submission)

        expected = [
          { short: true, title: "来訪者名", value: "SmartHR 須磨 英知 様" },
          { short: true, title: "訪問日時", value: "2023/01/01 08:00" }
        ]
        expect(instance.send(:received_message_attachment_fields)).to eq expected
      end
    end
  end
  describe "#notification_message_attachment_fields" do
    context "ok" do
      it do
        email_fixture = <<~EMAIL_BODY
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
        email = Email.new(email_fixture)
        instance = described_class.new(email: email)

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
  describe "#attachment" do
    context "default color" do
      it do
        expected = { fields: [],
                     color: "good" }
        args = { fields: [] }
        expect(instance.send(:attachment, args)).to eq expected
      end
    end
    context "not default color" do
      it do
        expected = { fields: [],
                     color: "#FFFFFF" }
        args = { fields: [],
                 color: "#FFFFFF" }
        expect(instance.send(:attachment, args)).to eq expected
      end
    end
  end
  describe "#attachment_field" do
    context "ok" do
      it do
        expected = { title: "title",
                     value: "value",
                     short: true }
        args = { title: "title",
                 value: "value" }
        expect(instance.send(:attachment_field, args)).to eq expected
      end
    end
  end
end
