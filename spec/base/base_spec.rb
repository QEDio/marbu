require 'spec_helper'

describe Marbu::Models::Base do
  context "a new Base instace" do
    let(:base) { Marbu::Models::Base.new }
    let(:modified_key_in_function) { 'value.key' }

    it "can be added a key without a function" do
      base.add_key('some_key')

      base.keys.first.name.should == 'some_key'
      base.keys.first.function.should == 'value.some_key'
    end

    it "can be added an emit key with a function" do
      base.add_key('some_key', 'some_function')

      base.keys.size.should == 1
      key = base.keys.first
      key.name.should == 'some_key'
      key.function.should == 'some_function'
    end

    # it "adds an emit_key with add_key(key)" do
    #   # base.add_key(@key)
    #   #
    #   # base.keys.size.should == 1
    #   # key = base.keys.first
    #   # key.name.should == @key
    #   # key.function.should == @modified_key_in_function
    # end
  end
end