require File.dirname(__FILE__) + '/test_helper.rb'

class TestMarbu < Test::Unit::TestCase
  context "creating a builder object for WorldWideBusiness" do
    setup do
    end

    should "should succeed" do
      @builder = Marbu::Builder.new(MR_WWB_LOC_DIM0)
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


