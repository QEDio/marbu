require 'spec_helper'

describe Marbu::Models::MapReduceFinalize do

  context "when instantiated with no params" do
    let(:mrf) { Marbu::Models::MapReduceFinalize.new }

    it "has a map" do
      mrf.map.should be_an_instance_of(Marbu::Models::Map)
    end

    it "has a reduce" do
      mrf.reduce.should be_an_instance_of(Marbu::Models::Reduce)
    end

    it "has a finalize" do
      mrf.finalize.should be_an_instance_of(Marbu::Models::Finalize)
    end
  end

  context "when instantiated with a valid params hash" do
    let(:mrf) { Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0) }

    it "return the serializable hash" do
      mrf.serializable_hash.should == MR_WWB_LOC_DIM0
    end
  end
end