# frozen_string_literal: true

require 'rails_helper'

require 'offcloud/file'

RSpec.describe Offcloud::File do
  subject { Offcloud::File.new(file_data) }

  let(:file_data) do
    {
      "requestId" => "618c082a04c4930cca8cc746",
      "fileName" => "ubuntu-21.10-desktop-amd64.iso",
      "site" => "",
      "status" => "downloaded",
      "originalLink" => "https://releases.ubuntu.com/21.10/ubuntu-21.10-desktop-amd64.iso.torrent?_ga=2.53896936.1142449133.1638376891-176919897.1638376891",
      "isDirectory" => false,
      "createdOn" => "2021-11-10T17:58:02.878Z",
      "server" => "ca-4"
    }
  end

  shared_examples "returns field" do |method_name, value|
    it "returns the expected value" do
      expect(subject.public_send(method_name)).to eq(value)
    end
  end

  include_examples "returns field", :file_name, "ubuntu-21.10-desktop-amd64.iso"
  include_examples "returns field", :original_link, "https://releases.ubuntu.com/21.10/ubuntu-21.10-desktop-amd64.iso.torrent?_ga=2.53896936.1142449133.1638376891-176919897.1638376891"
  include_examples "returns field", :status, "downloaded"
  include_examples "returns field", :is_directory, false
  include_examples "returns field", :created_on, "2021-11-10T17:58:02.878Z"
end
