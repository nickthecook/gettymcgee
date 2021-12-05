require 'rails_helper'

RSpec.describe "paths/new", type: :view do
  before(:each) do
    assign(:path, Path.new())
  end

  it "renders new path form" do
    render

    assert_select "form[action=?][method=?]", paths_path, "post" do
    end
  end
end
