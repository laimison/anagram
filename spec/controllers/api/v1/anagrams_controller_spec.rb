require 'rails_helper'

describe Api::V1::AnagramsController, type: :controller do
  include RSpec::Rails::ControllerExampleGroup
  
  describe "GET /v1/anagrams" do 
    subject { get "/v1/anagrams" , params: params } 
    let(:params) { { words: 'words' } }
    let(:words) { [""] }

    context "with a single anagram word" do
      let(:words) { ["piecrust"] }
      it "returns success response code & correct anagram" do
        # Unfinished
        # subject
        # assertion
      end
    end
  end
end