require File.dirname(__FILE__) + '/test_helper.rb'

class TestBuilder < Test::Unit::TestCase
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