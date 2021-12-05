require 'rails_helper'

RSpec.describe "paths/index", type: :view do
  before(:each) do
    assign(:paths, [
      Path.create!(),
      Path.create!()
    ])
  end

  it "renders a list of paths" do
    render
  end
end
