require 'rails_helper'

RSpec.describe "working_items/show", type: :view do
  before(:each) do
    @working_item = assign(:working_item, WorkingItem.create!(
      :work_type => "Work Type",
      :content => "Content",
      :version => 2,
      :status => 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Work Type/)
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
