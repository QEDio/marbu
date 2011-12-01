require 'spec_helper'

describe Marbu::Models::MapReduceFinalize do
  MAP_WWB_DIM0 =
    <<-JS
      count = 1;
    JS

  REDUCE_WWB_DIM0 =
    <<-JS
      var count = 0;
      values.forEach(function(v){
        count += v.count;
      });
    JS

  FINALIZE_WWB_DIM0 =
    <<-JS
    JS

  WWB_BASE_COLLECTION     =   "world_wide_business"

  MR_WWB_LOC_DIM0 =
  {
      :mapreduce_keys => [
          {:name => "DIM_LOC_0", :function => "value.DIM_LOC_0"}
        ],
      :mapreduce_values =>  [
          {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
          {:name => "count"}
        ],
      :finalize_values => [
          {:name => "DIM_LOC_0",            :function => "value.DIM_LOC_0"},
          {:name => "count",                :function => "value.count"}
      ],
      :database             => "qed_test",
      :base_collection      => WWB_BASE_COLLECTION,
      :mr_collection        => "#{WWB_BASE_COLLECTION}_mr_dim0",
      :query                => nil,
      :map                  => MAP_WWB_DIM0,
      :reduce               => REDUCE_WWB_DIM0,
      :finalize             => FINALIZE_WWB_DIM0
  }

  context "when instantiated with no params" do
    let(:mrm) do
      Marbu::Models::MapReduceFinalize.new
    end
    it "should return nil for map" do
      mrm.map.should be_nil
    end
    it "should return nil for reduce" do
      mrm.reduce.should be_nil
    end
    it "should return nil for finalize" do
      mrm.finalize.should be_nil
    end
  end

  context "when instantiated with a valid params hash" do
    let(:mrm) do
      Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0)
    end

    it "should return the serializable hash correctly" do
      mrm.serializable_hash.should == MR_WWB_LOC_DIM0
    end
  end

  context "when added an emit_key with no function" do
    let(:mrm) do
      Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0)
    end

    it "should create the function automatically" do
      pending
    end
  end
end