require 'spec_helper'

describe "/invoice items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  describe "find" do
    context "given an existing id" do
      it "finds an invoice item" do
        pending
      end

      it "finds all invoice items" do
        pending
      end
    end

    context "given an existing item id" do
      it "finds an invoice item" do
        pending
      end

      it "finds all invoice items" do
        pending
      end
    end

    context "given an existing invoice id" do
      it "finds an invoice item" do
        pending
      end

      it "finds all invoice items" do
        pending
      end
    end

    context "given an existing quantity" do
      it "finds an invoice item" do
        pending
      end

      it "finds all invoice items" do
        pending
      end
    end

    context "given an existing unit price" do
      it "finds an invoice item" do
        pending
      end

      it "finds all invoice items" do
        pending
      end
    end
  end

  describe "random" do
    it "returns a random invoice item instance" do
      pending
    end
  end

  describe "relationships" do
    context "given a specific invoice item" do
      it "returns the associated invoice" do
        pending
      end

      it "returns the associated items" do
        pending
      end
    end
  end
end