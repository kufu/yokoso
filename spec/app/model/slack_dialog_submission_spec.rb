# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/slack_dialog_submission"

describe SlackDialogSubmission do
  let(:instance) { described_class.new(post_body) }

  describe "#slack_user_id" do
    context "ok" do
      let(:post_body) { { user: { id: "UCKTXCBRB" } } }
      it { expect(instance.slack_user_id).to eq "UCKTXCBRB" }
    end
  end
  describe "#slack_channel_id" do
    context "ok" do
      let(:post_body) { { channel: { id: "CH15TJXEX" } } }
      it { expect(instance.slack_channel_id).to eq "CH15TJXEX" }
    end
  end
  describe "#recept_date" do
    context "ok" do
      let(:post_body) { { submission: { date: "2023/01/01" } } }
      it { expect(instance.recept_date).to eq "2023/01/01" }
    end
  end
  describe "#recept_time" do
    context "ok" do
      let(:post_body) { { submission: { time: "08:00" } } }
      it { expect(instance.recept_time).to eq "08:00" }
    end
  end
  describe "#company_name" do
    context "ok" do
      let(:post_body) { { submission: { company_name: "SmartHR" } } }
      it { expect(instance.company_name).to eq "SmartHR" }
    end
  end
  describe "#visitor_name" do
    context "ok" do
      let(:post_body) { { submission: { name: "須磨 太郎" } } }
      it { expect(instance.visitor_name).to eq "須磨 太郎" }
    end
  end
end
