# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/model/slack_dialog"

describe SlackDialog do
  let(:instance) { described_class.new }

  describe "#time_texts" do
    context "正常系" do
      it do
        expected = [{ label: "08:00", value: "08:00" },
                    { label: "08:30", value: "08:30" },
                    { label: "09:00", value: "09:00" },
                    { label: "09:30", value: "09:30" },
                    { label: "10:00", value: "10:00" },
                    { label: "10:30", value: "10:30" },
                    { label: "11:00", value: "11:00" },
                    { label: "11:30", value: "11:30" },
                    { label: "12:00", value: "12:00" },
                    { label: "12:30", value: "12:30" },
                    { label: "13:00", value: "13:00" },
                    { label: "13:30", value: "13:30" },
                    { label: "14:00", value: "14:00" },
                    { label: "14:30", value: "14:30" },
                    { label: "15:00", value: "15:00" },
                    { label: "15:30", value: "15:30" },
                    { label: "16:00", value: "16:00" },
                    { label: "16:30", value: "16:30" },
                    { label: "17:00", value: "17:00" },
                    { label: "17:30", value: "17:30" },
                    { label: "18:00", value: "18:00" },
                    { label: "18:30", value: "18:30" },
                    { label: "19:00", value: "19:00" },
                    { label: "19:30", value: "19:30" },
                    { label: "20:00", value: "20:00" },
                    { label: "20:30", value: "20:30" },
                    { label: "21:00", value: "21:00" },
                    { label: "21:30", value: "21:30" }]
        expect(described_class.new.send(:time_texts)).to eq expected
      end
    end
  end

  describe "#textarea_element" do
    context "ok" do
      it do
        expected = { label: "label",
                     type: "text",
                     name: "elements name",
                     placeholder: "placeholder" }
        expect(instance.send(label: "label",
                             name: "elements name",
                             placeholder: "placeholder")).to eq expected
      end
    end
  end
end
