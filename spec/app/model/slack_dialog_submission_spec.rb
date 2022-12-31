# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/slack_dialog_submission"

describe SlackDialogSubmittion do
  let(:instance) { described_class.new(post_body) }

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
      it { expect(instance.recept_time).to eq "SmartHR" }
    end
  end
  describe "#visitor_name" do
    context "ok" do
      let(:post_body) { { submission: { name: "須磨 太郎" } } }
      it { expect(instance.recept_time).to eq "須磨 太郎" }
    end
  end
end
