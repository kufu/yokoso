# frozen_string_literal: true

require "spec_helper"
require "json"
require_relative "../../../app/models/slack_modal_submission"

describe SlackModalSubmission do
  let(:instance) { described_class.new(post_body) }
  let(:fixture) do
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

  describe "#slack_user_id" do
    context "ok fixture" do
      let(:post_body) { fixture }
      it { expect(instance.slack_user_id).to eq "UCKTXCBRB" }
    end
  end
  describe "#recept_date" do
    context "ok fixture" do
      let(:post_body) { fixture }
      it { expect(instance.recept_date).to eq "2023/01/01" }
    end
  end
  describe "#recept_time" do
    context "ok fixture" do
      let(:post_body) { fixture }
      it { expect(instance.recept_time).to eq "08:00" }
    end
  end
  describe "#company_name" do
    context "ok fixture" do
      let(:post_body) { fixture }
      it { expect(instance.company_name).to eq "SmartHR" }
    end
  end
  describe "#visitor_name" do
    context "ok fixture" do
      let(:post_body) { fixture }
      it { expect(instance.visitor_name).to eq "須磨 英知" }
    end
  end
end
