# frozen_string_literal: true

require "spec_helper"

describe ChatMessageSender do
  let(:slack_client_mock) { instance_double(Slack::Web::Client) }
  before do
    allow(Slack::Web::Client).to receive(:new).and_return(slack_client_mock)
  end
  describe "#post_public_message" do
    let(:sender) { described_class.new }
    let(:post_body) do
      {
        icon_emoji: ":smile:",
        channel: "C1234567890",
        text: "Hello",
        as_user: true
      }
    end

    it "@slack_api_client.chat_postMessageにpost_bodyが渡される" do
      allow(slack_client_mock).to receive(:chat_postMessage).with(post_body)

      sender.post_public_message(post_body)
      expect(slack_client_mock).to have_received(:chat_postMessage).with(post_body)
    end
  end

  describe "#post_admission_badge_message" do
    let(:sender) { described_class.new(direct_message_id: "U1234567890") }
    context "file_pathsが空の場合" do
      before do
        allow(slack_client_mock).to receive(:chat_postMessage)
      end
      it "post_bodyに失敗メッセージがセットされてchat_postMessageが呼ばれる" do
        expect { sender.post_admission_badge_message({}) }.to raise_error("File Path is empty. Check Zapier Settings.")
        expect(slack_client_mock).to have_received(:chat_postMessage)
      end

      it "raiseエラーが発生する" do
        expect { sender.post_admission_badge_message({}) }.to raise_error("File Path is empty. Check Zapier Settings.")
      end
    end

    context "file_pathsが空でない場合" do
      let(:post_body) do
        {
          icon_emoji: ":office:",
          channel: "U1234567890",
          text: "Hello",
          as_user: true
        }
      end
      let(:file_paths) { ["./tmp/qrcode.pdf"] }
      let(:files) do
        [
          { id: "F1234567890", title: "qrcode.pdf" }
        ]
      end
      let(:posted_message_ts) { "1234567890" }

      let(:upload_url_external_response) do
        Hashie::Mash.new({
                            file_id: "F1234567890",
                            title: "qrcode.pdf",
                            url: "https://example.com/file_path",
                            file_path: "./tmp/qrcode.pdf"
                         })
      end

      let(:faraday_mock) { instance_double(Faraday::Connection) }
      let(:faraday_upload_io_mock) { instance_double(Faraday::UploadIO) }

      let(:file_klass_mock) { class_double(File) }
      before do
        allow(Faraday).to receive(:new).and_return(faraday_mock)
        allow(faraday_mock).to receive(:post)

        allow(Faraday::UploadIO).to receive(:new).and_return(faraday_upload_io_mock)

        allow(File).to receive(:size).with(file_paths[0]).and_return(100)
        allow(File).to receive(:basename).with(file_paths[0]).and_return("qrcode.pdf")

        allow(slack_client_mock).to receive(:chat_postMessage).with(post_body).and_return(
          Hashie::Mash.new({ ts: posted_message_ts })
        )
        allow(slack_client_mock).to receive(:files_completeUploadExternal)
        allow(slack_client_mock).to receive(:files_getUploadURLExternal).and_return(upload_url_external_response)
      end

      it "post_bodyにファイルが添付されてchat_postMessageが呼ばれる" do
        sender.post_admission_badge_message(post_body, file_paths: file_paths)
        expect(slack_client_mock).to have_received(:chat_postMessage).with(post_body)
      end

      it "ファイルをfaradayでアップロードする" do
        sender.post_admission_badge_message(post_body, file_paths: file_paths)
        expect(faraday_mock).to have_received(:post)
      end

      it "ファイルアップロードが完了させる" do
        sender.post_admission_badge_message(post_body, file_paths: file_paths)
        expect(slack_client_mock).to have_received(:files_completeUploadExternal).with(
          files: files.to_json,
          channel_id: "U1234567890",
          thread_ts: posted_message_ts
        )
      end
    end
  end
end
