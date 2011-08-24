module Marbu
  # the builder class is a lightweight container that holds a MapReduceModel and the requester Builder class
  # its basically a front for the internals of the builders
  class Builder
    attr_accessor :map_reduce_model

    def initialize(mrm, options = {})
      if mrm.is_a?(Marbu::MapReduceModel)
        @map_reduce_model = mrm
      elsif mrm.is_a?(Hash)
        @map_reduce_model = Marbu::MapReduceModel.new(mrm)
      else
        raise Exception.new("Parameter mrm was neither of type MapReduceModel nor Hash. Aborting")
      end
      
      @builder_clasz    = options[:builder] || Marbu::Builder::Mongodb
      @formatter_clasz  = options[:formatter] || Marbu::Formatter::Dummy
    end

    def map
      raise Marbu::Exceptions::NoEmitKeys if @map_reduce_model.map.keys.size == 0
      @formatter_clasz.perform(@builder_clasz.map(@map_reduce_model.map))
    end

    def reduce
      @formatter_clasz.perform(@builder_clasz.reduce(@map_reduce_model.reduce))
    end

    def finalize
      @formatter_clasz.perform(@builder_clasz.finalize(@map_reduce_model.finalize))
    end

    def query
      @map_reduce_model.query
    end

    def log
      self.to_s
    end

    def to_s
      puts "Map: #{map}"
      puts "Reduce: #{reduce}"
      puts "Finalize: #{finalize}"
    end
  end
end
