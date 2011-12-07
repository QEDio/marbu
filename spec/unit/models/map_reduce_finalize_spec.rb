require 'spec_helper'

describe Marbu::Models::MapReduceFinalize do

  context "when instantiated with no params" do
    let(:mrm) { Marbu::Models::MapReduceFinalize.new }

    it "has a map" do
      mrm.map.should be_an_instance_of(Marbu::Models::Map)
    end
    it "has a reduce" do
      mrm.reduce.should be_an_instance_of(Marbu::Models::Reduce)
    end
    it "has a finalize" do
      mrm.finalize.should be_an_instance_of(Marbu::Models::Finalize)
    end
  end

  context "when instantiated with a valid params hash" do
    let(:mrm) { Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0) }

    it "return the serializable hash" do
      mrm.serializable_hash.should == MR_WWB_LOC_DIM0
    end
  end

end