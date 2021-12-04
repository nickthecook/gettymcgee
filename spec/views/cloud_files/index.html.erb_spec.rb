require 'rails_helper'

RSpec.describe "cloud_files/index", type: :view do
  before(:each) do
    assign(:cloud_files, [
      CloudFile.create!(
        filename: "Filename",
        remote_status: "downloaded",
        original_link: "Original Link",
        directory: false
      ),
      CloudFile.create!(
        filename: "Filename",
        remote_status: "downloaded",
        original_link: "Original Link",
        directory: false
      )
    ])
  end

  it "renders a list of cloud_files" do
    render
    assert_select "tr>td", text: "Filename".to_s, count: 2
    assert_select "tr>td", text: "created", count: 2
    assert_select "tr>td", text: "downloaded", count: 2
    assert_select "tr>td", text: false.to_s, count: 2
  end
end
