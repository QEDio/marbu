require File.dirname(__FILE__) + '/test_helper.rb'

class TestMapReduceModel < Test::Unit::TestCase
  context "intializing a map_reduce object" do
    setup do
      @model = Marbu::MapReduceModel.new(MR_WWB_LOC_DIM0)
    end

    should "should create a builder" do
      @builder = Marbu::Builder.new({:map_reduce_model => @model})
    end

    should "create a map query" do
      @builder = Marbu::Builder.new({:map_reduce_model => @model})
      puts @builder.map
      puts @builder.reduce
      puts @builder.finalize
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


