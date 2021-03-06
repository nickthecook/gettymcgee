 require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/cloud_files", type: :request do
  
  # CloudFile. As you add validations to CloudFile, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    skip("Add a hash of attributes valid for your model")
  }

  let(:invalid_attributes) {
    skip("Add a hash of attributes invalid for your model")
  }

  describe "GET /index" do
    it "renders a successful response" do
      CloudFile.create! valid_attributes
      get cloud_files_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      cloud_file = CloudFile.create! valid_attributes
      get cloud_file_url(cloud_file)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_cloud_file_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "render a successful response" do
      cloud_file = CloudFile.create! valid_attributes
      get edit_cloud_file_url(cloud_file)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new CloudFile" do
        expect {
          post cloud_files_url, params: { cloud_file: valid_attributes }
        }.to change(CloudFile, :count).by(1)
      end

      it "redirects to the created cloud_file" do
        post cloud_files_url, params: { cloud_file: valid_attributes }
        expect(response).to redirect_to(cloud_file_url(CloudFile.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new CloudFile" do
        expect {
          post cloud_files_url, params: { cloud_file: invalid_attributes }
        }.to change(CloudFile, :count).by(0)
      end

      it "renders a successful response (i.e. to display the 'new' template)" do
        post cloud_files_url, params: { cloud_file: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested cloud_file" do
        cloud_file = CloudFile.create! valid_attributes
        patch cloud_file_url(cloud_file), params: { cloud_file: new_attributes }
        cloud_file.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the cloud_file" do
        cloud_file = CloudFile.create! valid_attributes
        patch cloud_file_url(cloud_file), params: { cloud_file: new_attributes }
        cloud_file.reload
        expect(response).to redirect_to(cloud_file_url(cloud_file))
      end
    end

    context "with invalid parameters" do
      it "renders a successful response (i.e. to display the 'edit' template)" do
        cloud_file = CloudFile.create! valid_attributes
        patch cloud_file_url(cloud_file), params: { cloud_file: invalid_attributes }
        expect(response).to be_successful
      end
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested cloud_file" do
      cloud_file = CloudFile.create! valid_attributes
      expect {
        delete cloud_file_url(cloud_file)
      }.to change(CloudFile, :count).by(-1)
    end

    it "redirects to the cloud_files list" do
      cloud_file = CloudFile.create! valid_attributes
      delete cloud_file_url(cloud_file)
      expect(response).to redirect_to(cloud_files_url)
    end
  end
end
