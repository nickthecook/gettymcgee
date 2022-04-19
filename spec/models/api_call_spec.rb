require 'rails_helper'

RSpec.describe ApiCall, type: :model do
  subject do
    ApiCall.create!(
      service: service,
      method: method,
      url: url,
      request: request,
      response: response,
      status_code: status_code
    )
  end

  let(:service) { :offcloud }
  let(:method) { :get }
  let(:url) { "https://example.com/app" }
  let(:request) { { "key" => "1234" } }
  let(:response) { { "result" => "ok" } }
  let(:status_code) { 200 }
end
