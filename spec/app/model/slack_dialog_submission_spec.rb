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
end
