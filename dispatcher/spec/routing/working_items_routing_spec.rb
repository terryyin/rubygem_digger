require "rails_helper"

RSpec.describe WorkingItemsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/working_items").to route_to("working_items#index")
    end

    it "routes to #new" do
      expect(:get => "/working_items/new").to route_to("working_items#new")
    end

    it "routes to #show" do
      expect(:get => "/working_items/1").to route_to("working_items#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/working_items/1/edit").to route_to("working_items#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/working_items").to route_to("working_items#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/working_items/1").to route_to("working_items#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/working_items/1").to route_to("working_items#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/working_items/1").to route_to("working_items#destroy", :id => "1")
    end

  end
end
