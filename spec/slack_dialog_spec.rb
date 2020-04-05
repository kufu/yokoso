# require_relative '../app/hello'
require 'spec_helper'
require 'rspec'
require 'rack/test'
require 'webmock/rspec'

RSpec.describe Yokoso do

  def app
    Yokoso
  end

  describe 'POST /dialog' do
    it "resupons is ok" do
      WebMock.enable!
      stub = stub_request(:post, /slack.com/).
        to_return(status: 200, body: "", headers: {})

      post '/dialog', params = { trigger_id: '13345224609.738474920.8088930838d88f008e0' }
      expect(stub).to have_been_requested
    end
  end
end