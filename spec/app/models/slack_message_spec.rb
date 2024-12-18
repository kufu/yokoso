# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/email"
require_relative "../../../app/models/slack_modal_submission"
require_relative "../../../app/models/slack_message"

describe SlackMessage do
  let(:instance) { described_class.new }

  describe "#received_message_post_body" do
    let!(:modal_submit_fixture) do
      { type: "view_submission",
        user: { id: "UCKTXCBRB" },
        view: {
          state: {
            values: {
              recept_date: { recept_date: { selected_option: { value: "2023/01/01" } } },
              recept_time: { recept_time: { selected_option: { value: "08:00" } } },
              recept_company: { recept_company: { value: "SmartHR" } },
              recept_name: { recept_name: { value: "須磨 英知" } }
            }
          }
        } }
    end
    let!(:modal_submission) { SlackModalSubmission.new(modal_submit_fixture) }
    let!(:instance) { described_class.new(modal_submission:) }
    context "チャンネルに通知する場合" do
      it "適切なメッセージが通知されること" do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("SEND_MODE").and_return("CHANNEL")

        expected = {
          as_user: true,
          channel: "UCKTXCBRB",
          icon_emoji: ":office:",
          text: "以下の内容で受け付けました。受け付け完了までしばらくお待ちください :pray:",
          attachments: [{
            color: "good",
            fields: instance.send(:received_message_attachment_fields)
          }]
        }
        expect(instance.send(:received_message_post_body)).to eq expected
      end
    end
    context "DMに通知する場合" do
      it "適切なメッセージが通知されること" do
        allow(ENV).to receive(:fetch).and_call_original
        allow(ENV).to receive(:fetch).with("SEND_MODE").and_return("DM")

        expected = {
          as_user: true,
          channel: "UCKTXCBRB",
          icon_emoji: ":office:",
          text: "以下の内容で受け付けました。受け付け完了までしばらくお待ちください :pray: \n受付が完了すると入館IDとバーコードがslackbotで届きます:mailbox_with_mail:",
          attachments: [{
            color: "good",
            fields: instance.send(:received_message_attachment_fields)
          }]
        }
        expect(instance.send(:received_message_post_body)).to eq expected
      end
    end
  end

  describe "#received_message_attachment_fields" do
    context "ok" do
      it do
        modal_submit_fixture = { type: "view_submission",
                                 user: { id: "UCKTXCBRB" },
                                 view: {
                                   state: {
                                     values: {
                                       recept_date: { recept_date: { selected_option: { value: "2023/01/01" } } },
                                       recept_time: { recept_time: { selected_option: { value: "08:00" } } },
                                       recept_company: { recept_company: { value: "SmartHR" } },
                                       recept_name: { recept_name: { value: "須磨 英知" } }
                                     }
                                   }
                                 } }
        modal_submission = SlackModalSubmission.new(modal_submit_fixture)
        instance = described_class.new(modal_submission:)

        expected = [
          { short: true, title: "来訪者名", value: "SmartHR 須磨 英知 様" },
          { short: true, title: "訪問日時", value: "2023/01/01 08:00" }
        ]
        expect(instance.send(:received_message_attachment_fields)).to eq expected
      end
    end
  end
  describe "#attachment" do
    context "default color" do
      it do
        expected = { fields: [],
                     color: "good" }
        args = { fields: [] }
        expect(instance.send(:attachment, **args)).to eq expected
      end
    end
    context "not default color" do
      it do
        expected = { fields: [],
                     color: "#FFFFFF" }
        args = { fields: [],
                 color: "#FFFFFF" }
        expect(instance.send(:attachment, **args)).to eq expected
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
        expect(instance.send(:attachment_field, **args)).to eq expected
      end
    end
  end
end
