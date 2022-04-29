require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  describe "#index" do
    it "returns a 200 response" do
      get :index
      expect(response).to have_http_status "200"
    end
  end

end
