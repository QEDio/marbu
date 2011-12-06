require 'spec_helper'

MONGODB_MAP_FUNCTION_ONE_LINE                 =
  "function(){value=this.value;count=1;emit({DIM_LOC_0:value.DIM_LOC_0},{DIM_LOC_0:value.DIM_LOC_0,count:count});}"
MONGODB_MAP_FUNCTION_TWO_EMIT_KEYS_ONE_LINE   =
  "function(){value=this.value;count=1;emit({DIM_LOC_0:value.DIM_LOC_0,DIM_LOC_1:value.DIM_LOC_1},{DIM_LOC_0:value.DIM_LOC_0,count:count});}"
MONGODB_REDUCE_FUNCTION_ONE_LINE              =
  "function(key,values){value=values[0];varcount=0;values.forEach(function(v){count+=v.count;});return{DIM_LOC_0:value.DIM_LOC_0,count:count};}"
MONGODB_FINALIZE_FUNCTION_ONE_LINE            =
  "function(key,value){count=(count/100)*100.0;return{DIM_LOC_0:value.DIM_LOC_0,count:value.count};}"

describe Marbu::Builder::Mongodb do
  context "for a mapreduce with one emit key" do
    let(:mrf) { Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0) }

    it "creates a map query" do
      Marbu::Builder::Mongodb.map(mrf.map).should_not be_empty
    end

    it 'creates the correct map query' do
       Marbu::Formatter::OneLine.perform(Marbu::Builder::Mongodb.map(mrf.map)).should == MONGODB_MAP_FUNCTION_ONE_LINE
    end

    it "creates a reduce query" do
      Marbu::Builder::Mongodb.reduce(mrf.reduce).should_not be_empty
    end

    it 'creates the correct reduce query' do
      Marbu::Formatter::OneLine.perform(Marbu::Builder::Mongodb.reduce(mrf.reduce)).should == MONGODB_REDUCE_FUNCTION_ONE_LINE
    end

    it "creates a finalize query" do
      Marbu::Builder::Mongodb.finalize(mrf.finalize).should_not be_empty
    end

    it 'create the correct finalize query' do
      Marbu::Formatter::OneLine.perform(Marbu::Builder::Mongodb.finalize(mrf.finalize)).should == MONGODB_FINALIZE_FUNCTION_ONE_LINE
    end
  end

  context "for a mapreduce with at least two emit keys" do
    let(:mrf) { Marbu::Models::MapReduceFinalize.new(MR_WWB_LOC_DIM0_TWO_MAP_EMIT_KEYS) }

    it "creates a map query" do
      Marbu::Builder::Mongodb.map(mrf.map).should_not be_empty
    end

    it 'creates the correct map query' do
      Marbu::Formatter::OneLine.perform(Marbu::Builder::Mongodb.map(mrf.map)).should == MONGODB_MAP_FUNCTION_TWO_EMIT_KEYS_ONE_LINE
    end
  end
end