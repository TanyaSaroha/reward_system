require 'rails_helper'

RSpec.describe RewardsController, :type => :controller do

  describe "POST rewards" do
    it "should calculate reward when valid input given" do
      @file = fixture_file_upload('input')
      post :calculate, params: {format: :json, file: @file}

      expect(response.status).to eq(200)

      response_body = JSON.parse(response.body)
      expect(response_body["A"]).to eq(1.75)
      expect(response_body["B"]).to eq(1.5)
      expect(response_body["C"]).to eq(1.0)
    end
  end
end
