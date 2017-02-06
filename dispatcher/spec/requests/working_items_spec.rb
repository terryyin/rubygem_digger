require 'rails_helper'

RSpec.describe "WorkingItems", type: :request do
  describe "GET /working_items" do
    it "works! (now write some real specs)" do
      get working_items_path
      expect(response).to have_http_status(200)
    end
  end
end
