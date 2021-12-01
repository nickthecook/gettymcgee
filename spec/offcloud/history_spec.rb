# frozen_string_literal: true

require 'rails_helper'
require 'offcloud/history'

RSpec.describe Offcloud::History do
  subject { Offcloud::History.new(files) }

  let(:files) do
    [
      {
        "requestId" => "618c082a04c4930cca8cc746",
        "fileName" => "file1.iso",
        "site" => "",
        "status" => "downloaded",
        "originalLink" => "https://example.com/file1.iso.torrent",
        "isDirectory" => false,
        "createdOn" => "2021-11-10T17:58:02.878Z",
        "server" => "ca-4"
      },
      {
        "requestId" => "518c082a04c4930cca8cc746",
        "fileName" => "file2.iso",
        "site" => "",
        "status" => "downloaded",
        "originalLink" => "https://example.com/file2.iso.torrent",
        "isDirectory" => false,
        "createdOn" => "2021-10-10T17:58:02.878Z",
        "server" => "ca-4"
      }
    ].to_json
  end

  describe "#files" do
    let(:result) { subject.files }

    it "returns an array of Files" do
      expect(result).to all(be_a(Offcloud::File))
    end

    it "returns the correct files" do
      expect(result.first.file_name).to eq("file1.iso")
      expect(result.second.file_name).to eq("file2.iso")
    end
  end
end
