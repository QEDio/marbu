require 'spec_helper'

describe Marbu::Models::Base do
  context "creating a Base Model" do
    let(:base) do
      @key                            = 'key'
      @function                       = 'function'
      @modified_key_in_function       = 'value.key'

      Marbu::Models::Base.new
    end

    it "adds a key object correctly" do
      base.add_key(@key.to_sym)

      base.keys.first.name.should == @key
      base.keys.first.function.should == @modified_key_in_function
    end

    it "adds an emit_key with add_key(key,function)" do
      base.add_key(@key, @function)

      base.keys.size.should == 1
      key = base.keys.first
      key.name.should == @key
      key.function.should == @function
    end

    it "adds an emit_key with add_key(key)" do
      base.add_key(@key)

      base.keys.size.should == 1
      key = base.keys.first
      key.name.should == @key
      key.function.should == @modified_key_in_function
    end
  end
end