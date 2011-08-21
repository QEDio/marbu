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
    should "return empty arrays or nil for it's values'" do
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
        assert_equal MR_WWB_LOC_DIM0, @mrm.hash
      end
  end
end