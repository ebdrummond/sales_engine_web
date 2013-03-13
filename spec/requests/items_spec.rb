require 'spec_helper'

describe "/items/" do
  include Rack::Test::Methods

  def app
    SalesEngineWeb::Server
  end

  describe "find" do
    context "given an existing id" do
      it "finds an item" do
        pending
      end

      it "finds all items" do
        pending
      end
    end

    context "given an existing name" do
      it "finds an item" do
        pending
      end

      it "finds an item, case insensitive" do
        pending
      end

      it "finds all items" do
        pending
      end
    end

    context "given an existing description" do
      it "finds an item" do
        pending
      end

      it "finds an item, case insensitive" do
        pending
      end

      it "finds all items" do
        pending
      end
    end

    context "given an existing unit price" do
      it "finds an item" do
        pending
      end

      it "finds all items" do
        pending
      end
    end

    context "given an existing merchant id" do
      it "finds an item" do
        pending
      end

      it "finds all items" do
        pending
      end
    end
  end

  describe "random" do
    it "returns a random items instance" do
      pending
    end
  end

  describe "relationships" do
    context "given a specific item" do
      it "returns a collection of associated invoice items" do
        pending
      end

      it "returns a collection of associated merchants" do
        pending
      end
    end
  end

  describe "business intelligence" do
    it "returns the top X items ranked by total revenue generated" do
      pending
    end

    it "returns the top X items ranked by total number sold" do
      pending
    end

    context "given a specific date" do
      it "returns the best selling item for that date" do
      end
    end
  end
end