require File.dirname(__FILE__) + '/test_helper.rb'

class TestMapReduceModel < Test::Unit::TestCase
  should "create correctly from hash and produce that hash again" do
    mrm = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)

    assert_equal MR_WWB_LOC_DIM0, mrm.hash
  end
end