require 'rails_helper'

RSpec.describe "cloud_files/new", type: :view do
  before(:each) do
    assign(:cloud_file, CloudFile.new(
      filename: "MyString",
      status: "downloaded",
      original_link: "MyString",
      directory: false
    ))
  end

  it "renders new cloud_file form" do
    render

    assert_select "form[action=?][method=?]", cloud_files_path, "post" do
      assert_select "input[name=?]", "cloud_file[filename]"
      assert_select "input[name=?]", "cloud_file[status]"
      assert_select "input[name=?]", "cloud_file[original_link]"
      assert_select "input[name=?]", "cloud_file[directory]"
    end
  end
end
