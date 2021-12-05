require 'rails_helper'

RSpec.describe "paths/edit", type: :view do
  before(:each) do
    @path = assign(:path, Path.create!())
  end

  it "renders the edit path form" do
    render

    assert_select "form[action=?][method=?]", path_path(@path), "post" do
    end
  end
end
