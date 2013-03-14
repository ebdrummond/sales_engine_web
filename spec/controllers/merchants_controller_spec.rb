require 'spec_helper'

module SalesEngineWeb
  describe MerchantsController do
    describe ".find" do
      it "returns a response" do
        params = {:id => 0}
        expect( MerchantsController.find(params) ).to be_kind_of Response
      end

      context "with an id that exists" do
        let(:merchant){ Merchant.create(:name => "Turkey") }

        it "returns a JSON version of the matching merchant" do
          response = MerchantsController.find( :id => merchant.id )
          output = JSON.parse(response.body)
          expect( output['id'] ).to eq merchant.id
        end
      end
    end

    describe '.find_all' do
      context "given the name of existing merchants" do
        let!(:merchant1){ Merchant.create(:name => "Turkey") }
        let!(:merchant2){ Merchant.create(:name => "Turkey") }
        let!(:merchant3){ Merchant.create(:name => "Ham") }

        it "returns the merchants as JSON" do
          response = MerchantsController.find_all(:name => merchant1.name)
          output = JSON.parse(response.body)
          expect( output.count ).to eq 2
          output.each do |o|
            expect( o['name'] ).to eq merchant1.name
          end
        end
      end
    end
  end
end