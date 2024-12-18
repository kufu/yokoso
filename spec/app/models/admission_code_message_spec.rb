# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/email"
require_relative "../../../app/models/admission_code_message"
require_relative "../../../app/models/chat_message_sender"

describe AdmissionCodeMessage do
  let(:instance) { described_class.new(email) }
  let(:email) { Email.new(email_fixture) }
  let!(:email_fixture) do
    <<~EMAIL_BODY
      To:【U9999999999】test test(test) 様<BR>\r
      <BR>\r
      平素は格別なご高配を賜り、厚く御礼申し上げます。株式会社SmartHRです。<BR>\r
      以下のとおり入館申請を行いました。<BR>\r
      I have registered your admission application as below.<BR>\r
      <BR>\r
      =========================================================<BR>\r
      <BR>\r
      ■　ご来訪日時/Date<BR>\r
      2024/12/18(Wed) 10:00<BR>\r
      <BR>\r
      ■　ビル/Building<BR>\r
      住友不動産六本木グランドタワー/SUMITOMO FUDOSAN ROPPONGI GRAND TOWER<BR>\r
      東京都港区六本木3-2-1<BR>\r
      <BR>\r
      ■　入館ＩＤ/Guest ID<BR>\r
      54620<BR>\r
      <BR>\r
      <BR>\r
    EMAIL_BODY
  end


  describe "#post" do
    context "SEND_MODE が CHANNEL の場合" do
      it "post_public_message が1回呼ばれること" do
        allow(ENV).to receive(:fetch).with("SEND_MODE").and_return("CHANNEL")
        allow(ENV).to receive(:fetch).with("SLACK_CHANNEL").and_return("CH15TJXEX")
        chat_message_sender = instance_double(ChatMessageSender)
        allow(ChatMessageSender).to receive(:new).and_return(chat_message_sender)
        allow(chat_message_sender).to receive(:post_public_message)

        instance.post

        expect(chat_message_sender).to have_received(:post_public_message).once
      end
    end

    context "SEND_MODE が DM の場合" do
      it "post_direct_message が1回呼ばれること" do
        allow(ENV).to receive(:fetch).with("SEND_MODE").and_return("DM")
        allow(ENV).to receive(:fetch).with("SLACK_CHANNEL").and_return("CH15TJXEX")
        chat_message_sender = instance_double(ChatMessageSender)
        allow(ChatMessageSender).to receive(:new).and_return(chat_message_sender)
        allow(chat_message_sender).to receive(:post_public_message)

        instance.post

        expect(chat_message_sender).to have_received(:post_public_message).once
      end
    end

    context "SEND_MODE が BOTH の場合" do
      it "post_public_message が2回呼ばれること" do
        allow(ENV).to receive(:fetch).with("SEND_MODE").and_return("BOTH")
        allow(ENV).to receive(:fetch).with("SLACK_CHANNEL").and_return("CH15TJXEX")
        chat_message_sender = instance_double(ChatMessageSender)
        allow(ChatMessageSender).to receive(:new).and_return(chat_message_sender)
        allow(chat_message_sender).to receive(:post_public_message)

        instance.post

        expect(chat_message_sender).to have_received(:post_public_message).twice
      end
    end
  end

  describe "#api_post_body" do
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
          fields: instance.send(:attachment_fields)
        }]
      }
      expect(instance.send(:api_post_body)).to eq expected
    end
  end
  describe "#attachment_fields" do
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
      expect(instance.send(:attachment_fields)).to eq expected
    end
  end
end
