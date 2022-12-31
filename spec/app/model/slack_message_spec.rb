# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/slack_message"
describe SlackMessage do
  let(:instance) { described_class.new }

  describe "#attachment_field" do
    context "ok" do
      it do
        expected = { title: "title",
                     value: "タイトル",
                     short: true }
        expect(instance.send(:attachment_field)).to eq expected
      end
    end
  end
end
