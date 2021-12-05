# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Offcloud::Client do
  describe "#fetch" do
    let(:history_double) { instance_double(Offcloud::History) }
    let(:get_response) { instance_double(HTTParty::Response, parsed_response: { body: "ydob" }) }

    before do
      allow(ENV).to receive(:[]).and_call_original
      allow(ENV).to receive(:[]).with("OFFCLOUD_API_KEY").and_return("1234")
      allow(Offcloud::History).to receive(:new).and_return(history_double)
      allow(HTTParty).to receive(:get).and_return(get_response)
    end

    describe "#fetch" do
      let(:result) { subject.fetch }

      it "creates a History instance with the correct data" do
        expect(Offcloud::History).to receive(:new).with({ body: "ydob" })
        result
      end

      it "returns a history instance" do
        expect(result).to eq(history_double)
      end

      it "gets history from the server" do
        expect(HTTParty).to receive(:get).with("https://offcloud.com/api/cloud/history", query: { key: "1234" })
        result
      end
    end
  end
end
