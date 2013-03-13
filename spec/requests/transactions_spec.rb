require 'spec_helper'

describe "/transactions/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  describe "find" do
    context "given an existing id" do
      it "finds the transaction" do
        pending
      end

      it "finds all transactions associated with the id" do
        pending
      end
    end

    context "given an existing invoice id" do
      it "finds a transaction" do
        pending
      end

      it "finds all transactions" do
        pending
      end
    end

    context "given an existing credit card number" do
      it "finds a transaction" do
        pending
      end

      it "finds all transactions" do
        pending
      end
    end

    context "given an existing result" do
      it "finds a transaction" do
        pending
      end

      it "finds all transactions" do
        pending
      end
    end
  end

  describe "random" do
    it "returns a random transaction instance" do
      pending
    end
  end

  describe "relationships" do
    context "given a specific transaction" do
      it "returns the associated invoice" do
        pending
      end
    end
  end
end