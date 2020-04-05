require 'spec_helper'

RSpec.describe Yokoso do

  def app
    Yokoso
  end

  it "get / response is ok" do
    get '/'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Hello World')
  end

  it "post /dialog response is ok" do
    WebMock.enable!
    stub = stub_request(:post, /slack.com/).
      to_return(status: 200, body: "", headers: {})

    post '/dialog', params = { trigger_id: '13345224609.738474920.8088930838d88f008e0' }
    expect(last_response).to be_ok
  end
end