require File.dirname(__FILE__) + '/../test_helper.rb'

class TestBuilderMongodb < Test::Unit::TestCase
  context "using the Marbu::Builder::Mongodb class" do
    context "for a mapreduce with one emit key" do
      setup do
        @mrm              = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)
        @builder_clasz    = Marbu::Builder::Mongodb
      end

      should "create a map query" do
        assert @builder_clasz.map(@mrm.map).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct map query' do
        assert_equal MONGODB_MAP_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.map(@mrm.map))
      end

      should "create a reduce query" do
        assert @builder_clasz.reduce(@mrm.reduce).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct reduce query' do
        assert_equal MONGODB_REDUCE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.reduce(@mrm.reduce))
      end

      should "create a finalize query" do
        assert @builder_clasz.finalize(@mrm.finalize).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct finalize query' do
        assert_equal MONGODB_FINALIZE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.finalize(@mrm.finalize))
      end
    end

    context "for a mapreduce with at least two emit keys" do
      setup do
        @mrm              = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0_TWO_MAP_EMIT_KEYS)
        @builder_clasz    = Marbu::Builder::Mongodb
      end

      should "create a map query" do
        assert @builder_clasz.map(@mrm.map).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct map query' do
        assert_equal MONGODB_MAP_FUNCTION_TWO_EMIT_KEYS_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.map(@mrm.map))
      end

      should "create a reduce query" do
        assert @builder_clasz.reduce(@mrm.reduce).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct reduce query' do
        assert_equal MONGODB_REDUCE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.reduce(@mrm.reduce))
      end

      should "create a finalize query" do
        assert @builder_clasz.finalize(@mrm.finalize).size > 0, "Didn't return a correctly build map object'"
      end

      should 'create the correct finalize query' do
        assert_equal MONGODB_FINALIZE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder_clasz.finalize(@mrm.finalize))
      end
    end
  end
end
