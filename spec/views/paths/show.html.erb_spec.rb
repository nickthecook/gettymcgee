require 'rails_helper'

RSpec.describe "paths/show", type: :view do
  before(:each) do
    @path = assign(:path, Path.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
