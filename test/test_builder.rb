require File.dirname(__FILE__) + '/test_helper.rb'

class TestBuilder < Test::Unit::TestCase
  context "intializing a map_reduce object" do
    setup do
      @mrm        = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)
      @builder    = Marbu::Builder.new( @mrm)
    end

    should "create a map query" do
      assert @builder.map.size > 0, "Didn't return a correctly build map object'"
    end

    should 'create the correct map query' do
      assert_equal MAP_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder.map)
    end

    should "create a reduce query" do
      assert @builder.reduce.size > 0, "Didn't return a correctly build map object'"
    end

    should 'create the correct reduce query' do
      assert_equal REDUCE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder.reduce)
    end

    should "create a finalize query" do
      assert @builder.finalize.size > 0, "Didn't return a correctly build map object'"
    end

    should 'create the correct finalize query' do
      assert_equal FINALIZE_FUNCTION_ONE_LINE, Marbu::Formatter::OneLine.perform(@builder.finalize)
    end
  end

  context "when requesting the map code" do
    context "and no map emit keys are defined it" do
      setup do
        @mrm        = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0_NO_MAP_EMIT_KEYS)
        @builder    = Marbu::Builder.new(@mrm)
      end

      should "raise NoEmitKeysDefined" do
        assert_raise Marbu::Exceptions::NoEmitKeys do
          @builder.map
        end
      end
    end
  end

  context "builder objects" do
    #setup do
    #  @fm = FilterModel.new(Qed::Mongodb::Test::Factory::WorldWideBusiness::PARAMS_WORLD_WIDE_BUSINESS)
    #  @fm.drilldown_level_current = 2
    #  @fm.user = USER
    #  @builders = Qed::Mongodb::StatisticViewConfig.create_config(@fm, MAPREDUCE_CONFIG)
    #end
    #
    #should "return valid map javascript" do
    #  @builders.each do |builder|
    #    puts builder.map
    #  end
    #end
  end
end