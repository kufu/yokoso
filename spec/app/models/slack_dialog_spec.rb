# frozen_string_literal: true

require "spec_helper"
require_relative "../../../app/models/slack_dialog"

describe SlackDialog do
  let(:instance) { described_class.new }

  describe "#post_body" do
    context "ok" do
      it do
        expected = {
          trigger_id: "trigger_id",
          dialog: {
            title: "六本木グランドタワー入館受付申請",
            callback_id: "callback_id",
            submit_label: "送信",
            elements: [{ label: "来訪日",
                         type: "select",
                         name: "date",
                         options: instance.send(:date_select_options) },
                       { label: "訪問時間",
                         type: "select",
                         name: "time",
                         options: instance.send(:time_select_options) },
                       { label: "来訪者会社名",
                         type: "text",
                         name: "company_name",
                         placeholder: "会社名がない場合は「面接」「なし」等" },
                       { label: "来訪者名",
                         type: "text",
                         name: "name",
                         placeholder: "「様」をつけると入館証が「様様」になるよ！" }]
          }
        }
        expect(instance.send(:post_body, "trigger_id")).to eq expected
      end
    end
  end
  describe "#textarea_element" do
    context "ok" do
      it do
        expected = { label: "label",
                     type: "text",
                     name: "element name",
                     placeholder: "placeholder" }
        args = { label: "label",
                 name: "element name",
                 placeholder: "placeholder" }
        expect(instance.send(:textarea_element, **args)).to eq expected
      end
    end
  end
  describe "#select_element" do
    context "ok" do
      it do
        expected = { label: "label",
                     type: "select",
                     name: "element name",
                     options: [] }
        args = { label: "label",
                 name: "element name",
                 options: [] }
        expect(instance.send(:select_element, **args)).to eq expected
      end
    end
  end
  describe "#date_select_options" do
    context "ok" do
      it do
        expected = [{ text: { text: "2022/12/31 土", type: "plain_text" }, value: "2022/12/31" },
                    { text: { text: "2023/01/01 日", type: "plain_text" }, value: "2023/01/01" },
                    { text: { text: "2023/01/02 月", type: "plain_text" }, value: "2023/01/02" },
                    { text: { text: "2023/01/03 火", type: "plain_text" }, value: "2023/01/03" },
                    { text: { text: "2023/01/04 水", type: "plain_text" }, value: "2023/01/04" },
                    { text: { text: "2023/01/05 木", type: "plain_text" }, value: "2023/01/05" },
                    { text: { text: "2023/01/06 金", type: "plain_text" }, value: "2023/01/06" },
                    { text: { text: "2023/01/07 土", type: "plain_text" }, value: "2023/01/07" },
                    { text: { text: "2023/01/08 日", type: "plain_text" }, value: "2023/01/08" },
                    { text: { text: "2023/01/09 月", type: "plain_text" }, value: "2023/01/09" },
                    { text: { text: "2023/01/10 火", type: "plain_text" }, value: "2023/01/10" },
                    { text: { text: "2023/01/11 水", type: "plain_text" }, value: "2023/01/11" },
                    { text: { text: "2023/01/12 木", type: "plain_text" }, value: "2023/01/12" },
                    { text: { text: "2023/01/13 金", type: "plain_text" }, value: "2023/01/13" },
                    { text: { text: "2023/01/14 土", type: "plain_text" }, value: "2023/01/14" },
                    { text: { text: "2023/01/15 日", type: "plain_text" }, value: "2023/01/15" },
                    { text: { text: "2023/01/16 月", type: "plain_text" }, value: "2023/01/16" },
                    { text: { text: "2023/01/17 火", type: "plain_text" }, value: "2023/01/17" },
                    { text: { text: "2023/01/18 水", type: "plain_text" }, value: "2023/01/18" },
                    { text: { text: "2023/01/19 木", type: "plain_text" }, value: "2023/01/19" },
                    { text: { text: "2023/01/20 金", type: "plain_text" }, value: "2023/01/20" },
                    { text: { text: "2023/01/21 土", type: "plain_text" }, value: "2023/01/21" },
                    { text: { text: "2023/01/22 日", type: "plain_text" }, value: "2023/01/22" },
                    { text: { text: "2023/01/23 月", type: "plain_text" }, value: "2023/01/23" },
                    { text: { text: "2023/01/24 火", type: "plain_text" }, value: "2023/01/24" },
                    { text: { text: "2023/01/25 水", type: "plain_text" }, value: "2023/01/25" },
                    { text: { text: "2023/01/26 木", type: "plain_text" }, value: "2023/01/26" },
                    { text: { text: "2023/01/27 金", type: "plain_text" }, value: "2023/01/27" },
                    { text: { text: "2023/01/28 土", type: "plain_text" }, value: "2023/01/28" },
                    { text: { text: "2023/01/29 日", type: "plain_text" }, value: "2023/01/29" },
                    { text: { text: "2023/01/30 月", type: "plain_text" }, value: "2023/01/30" },
                    { text: { text: "2023/01/31 火", type: "plain_text" }, value: "2023/01/31" },
                    { text: { text: "2023/02/01 水", type: "plain_text" }, value: "2023/02/01" },
                    { text: { text: "2023/02/02 木", type: "plain_text" }, value: "2023/02/02" },
                    { text: { text: "2023/02/03 金", type: "plain_text" }, value: "2023/02/03" },
                    { text: { text: "2023/02/04 土", type: "plain_text" }, value: "2023/02/04" },
                    { text: { text: "2023/02/05 日", type: "plain_text" }, value: "2023/02/05" },
                    { text: { text: "2023/02/06 月", type: "plain_text" }, value: "2023/02/06" },
                    { text: { text: "2023/02/07 火", type: "plain_text" }, value: "2023/02/07" },
                    { text: { text: "2023/02/08 水", type: "plain_text" }, value: "2023/02/08" },
                    { text: { text: "2023/02/09 木", type: "plain_text" }, value: "2023/02/09" },
                    { text: { text: "2023/02/10 金", type: "plain_text" }, value: "2023/02/10" },
                    { text: { text: "2023/02/11 土", type: "plain_text" }, value: "2023/02/11" },
                    { text: { text: "2023/02/12 日", type: "plain_text" }, value: "2023/02/12" },
                    { text: { text: "2023/02/13 月", type: "plain_text" }, value: "2023/02/13" },
                    { text: { text: "2023/02/14 火", type: "plain_text" }, value: "2023/02/14" },
                    { text: { text: "2023/02/15 水", type: "plain_text" }, value: "2023/02/15" },
                    { text: { text: "2023/02/16 木", type: "plain_text" }, value: "2023/02/16" },
                    { text: { text: "2023/02/17 金", type: "plain_text" }, value: "2023/02/17" },
                    { text: { text: "2023/02/18 土", type: "plain_text" }, value: "2023/02/18" },
                    { text: { text: "2023/02/19 日", type: "plain_text" }, value: "2023/02/19" },
                    { text: { text: "2023/02/20 月", type: "plain_text" }, value: "2023/02/20" },
                    { text: { text: "2023/02/21 火", type: "plain_text" }, value: "2023/02/21" },
                    { text: { text: "2023/02/22 水", type: "plain_text" }, value: "2023/02/22" },
                    { text: { text: "2023/02/23 木", type: "plain_text" }, value: "2023/02/23" },
                    { text: { text: "2023/02/24 金", type: "plain_text" }, value: "2023/02/24" },
                    { text: { text: "2023/02/25 土", type: "plain_text" }, value: "2023/02/25" },
                    { text: { text: "2023/02/26 日", type: "plain_text" }, value: "2023/02/26" },
                    { text: { text: "2023/02/27 月", type: "plain_text" }, value: "2023/02/27" },
                    { text: { text: "2023/02/28 火", type: "plain_text" }, value: "2023/02/28" },
                    { text: { text: "2023/03/01 水", type: "plain_text" }, value: "2023/03/01" },
                    { text: { text: "2023/03/02 木", type: "plain_text" }, value: "2023/03/02" },
                    { text: { text: "2023/03/03 金", type: "plain_text" }, value: "2023/03/03" },
                    { text: { text: "2023/03/04 土", type: "plain_text" }, value: "2023/03/04" },
                    { text: { text: "2023/03/05 日", type: "plain_text" }, value: "2023/03/05" },
                    { text: { text: "2023/03/06 月", type: "plain_text" }, value: "2023/03/06" },
                    { text: { text: "2023/03/07 火", type: "plain_text" }, value: "2023/03/07" },
                    { text: { text: "2023/03/08 水", type: "plain_text" }, value: "2023/03/08" },
                    { text: { text: "2023/03/09 木", type: "plain_text" }, value: "2023/03/09" },
                    { text: { text: "2023/03/10 金", type: "plain_text" }, value: "2023/03/10" },
                    { text: { text: "2023/03/11 土", type: "plain_text" }, value: "2023/03/11" },
                    { text: { text: "2023/03/12 日", type: "plain_text" }, value: "2023/03/12" },
                    { text: { text: "2023/03/13 月", type: "plain_text" }, value: "2023/03/13" },
                    { text: { text: "2023/03/14 火", type: "plain_text" }, value: "2023/03/14" },
                    { text: { text: "2023/03/15 水", type: "plain_text" }, value: "2023/03/15" },
                    { text: { text: "2023/03/16 木", type: "plain_text" }, value: "2023/03/16" },
                    { text: { text: "2023/03/17 金", type: "plain_text" }, value: "2023/03/17" },
                    { text: { text: "2023/03/18 土", type: "plain_text" }, value: "2023/03/18" },
                    { text: { text: "2023/03/19 日", type: "plain_text" }, value: "2023/03/19" },
                    { text: { text: "2023/03/20 月", type: "plain_text" }, value: "2023/03/20" },
                    { text: { text: "2023/03/21 火", type: "plain_text" }, value: "2023/03/21" },
                    { text: { text: "2023/03/22 水", type: "plain_text" }, value: "2023/03/22" },
                    { text: { text: "2023/03/23 木", type: "plain_text" }, value: "2023/03/23" },
                    { text: { text: "2023/03/24 金", type: "plain_text" }, value: "2023/03/24" },
                    { text: { text: "2023/03/25 土", type: "plain_text" }, value: "2023/03/25" },
                    { text: { text: "2023/03/26 日", type: "plain_text" }, value: "2023/03/26" },
                    { text: { text: "2023/03/27 月", type: "plain_text" }, value: "2023/03/27" },
                    { text: { text: "2023/03/28 火", type: "plain_text" }, value: "2023/03/28" },
                    { text: { text: "2023/03/29 水", type: "plain_text" }, value: "2023/03/29" },
                    { text: { text: "2023/03/30 木", type: "plain_text" }, value: "2023/03/30" }]

        travel_to Date.new(2022, 12, 31) do
          expect(instance.send(:date_select_options)).to eq expected
        end
      end
    end
  end
  describe "#time_select_options" do
    context "ok" do
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
        expect(instance.send(:time_select_options)).to eq expected
      end
    end
  end
end
