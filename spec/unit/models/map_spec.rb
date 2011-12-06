require 'spec_helper'

describe Marbu::Models::Map do
  context "when instantiated with empty parameters" do
    let(:map) do
      Marbu::Models::Map.new
    end

    it "should have no keys" do
      map.keys.should be_empty
    end

    it "should have no values" do
      map.values.should be_empty
    end

    it "should have no code" do
      map.code.present?.should be_false
    end
  end
end

