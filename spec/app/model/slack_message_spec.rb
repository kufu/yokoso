# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/slack_message"
describe SlackMessage do
  let(:instance) { described_class.new }

  describe "#attachments" do
    context "default color" do
      it do
        expected = { fields: [],
                     color: "good" }
        args = { fields: [] }
        expect(instance.send(:attachments, args)).to eq expected
      end
    end
    context "not default color" do
      it do
        expected = { fields: [],
                     color: "#FFFFFF" }
        args = { fields: [],
                 color: "#FFFFFF" }
        expect(instance.send(:attachments, args)).to eq expected
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
