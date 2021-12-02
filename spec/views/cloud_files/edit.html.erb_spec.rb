require 'rails_helper'

RSpec.describe "cloud_files/edit", type: :view do
  before(:each) do
    @cloud_file = assign(:cloud_file, CloudFile.create!(
      filename: "MyString",
      status: "downloaded",
      original_link: "MyString",
      directory: false
    ))
  end

  it "renders the edit cloud_file form" do
    render

    assert_select "form[action=?][method=?]", cloud_file_path(@cloud_file), "post" do

      assert_select "input[name=?]", "cloud_file[filename]"

      assert_select "input[name=?]", "cloud_file[status]"

      assert_select "input[name=?]", "cloud_file[original_link]"

      assert_select "input[name=?]", "cloud_file[directory]"
    end
  end
end
