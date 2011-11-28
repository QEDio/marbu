require 'spec_helper'

describe Marbu::Models::Map do
  context "creating a MapModel with no parameters" do
    let(:map) do
      Marbu::Models::Map.new
    end

    it "returns an empty arrays or nil for it's values" do
      map.keys.should == []
      map.values.should == []
      map.code.should == nil
    end
  end
end

