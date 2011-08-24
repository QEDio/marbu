require File.dirname(__FILE__) + '/test_helper.rb'

class TestMapReduceModel < Test::Unit::TestCase
  context "when creating with no options the model" do
    setup do
      @mrm = Marbu::MapReduceModel.new
    end

    should "return nil for map, reduce and finalize" do
      assert_nil @mrm.map
      assert_nil @mrm.reduce
      assert_nil @mrm.finalize
    end
  end

  context "creating a MapModel with no parameters" do
    should "return a empty arrays or nil for it's values" do
      map_model = Marbu::MapReduceModel::MapModel.new

      assert_equal [], map_model.keys
      assert_equal [], map_model.values
      assert_nil map_model.code
    end
  end

  context "when creating with a valid params hash it" do
    setup do
      @mrm = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)
    end
    should "create correctly and produce that hash again" do
      assert_equal MR_WWB_LOC_DIM0, @mrm.serializable_hash
    end
  end

  context "when adding a emit_key with no function it" do
    setup do
      @mrm = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)
    end
    should "create the function automatically" do

    end
  end

  ################### base model tests #############################

  context "BaseModel" do
    setup do
      @key                            = 'key'
      @function                       = 'function'
      @modified_key_in_function       = 'value.key'
      @bm                             = Marbu::MapReduceModel::BaseModel.new
    end

    context "adding an emit_key with add_key(key,function)" do
      setup do
        @bm.add_key(@key, @function)
      end

      should "add the keys and return them unchanged" do
        assert_equal 1, @bm.keys.size
        key = @bm.keys.first
        assert_equal @key, key.name
        assert_equal @function, key.function
      end
    end

    context "adding an emit_key with add_key(key)" do
      setup do
        @bm.add_key(@key)
      end

      should "add the key and create the function with 'value.key'" do
        assert_equal 1, @bm.keys.size
        key = @bm.keys.first
        assert_equal @key, key.name
        assert_equal @modified_key_in_function, key.function
      end
    end
  end
end