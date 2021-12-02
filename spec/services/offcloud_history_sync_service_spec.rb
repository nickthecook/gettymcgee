# frozen_string_literal: true

require 'rails_helper'
require 'ostruct'

RSpec.describe OffcloudHistorySyncService do
  let(:client_double) { instance_double(Offcloud::Client, fetch: OpenStruct.new(files: files)) }
  let(:files) do
    [
      Offcloud::File.new({
        "requestId" => "1234",
        "fileName" => "file1.iso",
        "site" => "",
        "status" => "downloaded",
        "originalLink" => "https://example.com/file1.iso.torrent",
        "isDirectory" => false,
        "createdOn" => "2021-11-10T17:58:02.878Z",
        "server" => "ca-4"
      }),
      Offcloud::File.new({
        "requestId" => "5678",
        "fileName" => "file2.iso",
        "site" => "",
        "status" => "downloaded",
        "originalLink" => "https://example.com/file2.iso.torrent",
        "isDirectory" => false,
        "createdOn" => "2021-10-10T17:58:02.878Z",
        "server" => "ca-4"
      })
    ]
  end

  before do
    allow(Offcloud::Client).to receive(:new).and_return(client_double)
  end

  describe "#execute" do
    let(:execute) { subject.execute }

    it "creates file records locally" do
      execute
      expect(CloudFile.first).to have_attributes(
        remote_id: "1234",
        filename: "file1.iso",
        status: "downloaded",
        original_link: "https://example.com/file1.iso.torrent",
        directory: false,
        remote_created_at: Time.parse("2021-11-10T17:58:02.878Z")
      )
      expect(CloudFile.second).to have_attributes(
        remote_id: "5678",
        filename: "file2.iso",
        status: "downloaded",
        original_link: "https://example.com/file2.iso.torrent",
        directory: false,
        remote_created_at: Time.parse("2021-10-10T17:58:02.878Z")
      )
    end
  end
end
