require 'rails_helper'

RSpec.describe 'working_items/edit', type: :view do
  before(:each) do
    @working_item = assign(:working_item, WorkingItem.create!(
                                            work_type: 'MyString',
                                            content: 'MyString',
                                            version: 1,
                                            status: 1
    ))
  end

  it 'renders the edit working_item form' do
    render

    assert_select 'form[action=?][method=?]', working_item_path(@working_item), 'post' do
      assert_select 'input#working_item_work_type[name=?]', 'working_item[work_type]'

      assert_select 'input#working_item_content[name=?]', 'working_item[content]'

      assert_select 'input#working_item_version[name=?]', 'working_item[version]'

      assert_select 'input#working_item_status[name=?]', 'working_item[status]'
    end
  end
end
