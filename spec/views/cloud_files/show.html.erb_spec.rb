require 'rails_helper'

RSpec.describe "cloud_files/show", type: :view do
  before(:each) do
    @cloud_file = assign(:cloud_file, CloudFile.create!(
      filename: "Filename",
      status: 2,
      original_link: "Original Link",
      directory: false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Filename/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/Original Link/)
    expect(rendered).to match(/false/)
  end
end
