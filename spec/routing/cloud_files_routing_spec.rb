require "rails_helper"

RSpec.describe CloudFilesController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(get: "/cloud_files").to route_to("cloud_files#index")
    end

    it "routes to #new" do
      expect(get: "/cloud_files/new").to route_to("cloud_files#new")
    end

    it "routes to #show" do
      expect(get: "/cloud_files/1").to route_to("cloud_files#show", id: "1")
    end

    it "routes to #edit" do
      expect(get: "/cloud_files/1/edit").to route_to("cloud_files#edit", id: "1")
    end


    it "routes to #create" do
      expect(post: "/cloud_files").to route_to("cloud_files#create")
    end

    it "routes to #update via PUT" do
      expect(put: "/cloud_files/1").to route_to("cloud_files#update", id: "1")
    end

    it "routes to #update via PATCH" do
      expect(patch: "/cloud_files/1").to route_to("cloud_files#update", id: "1")
    end

    it "routes to #destroy" do
      expect(delete: "/cloud_files/1").to route_to("cloud_files#destroy", id: "1")
    end
  end
end
