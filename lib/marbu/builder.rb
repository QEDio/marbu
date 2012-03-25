# -*- encoding: utf-8 -*-

module Marbu
  # the builder class is a lightweight container that holds a MapReduceModel and the requester Builder class
  # its basically a front for the internals of the builders
  class Builder
    attr_accessor :map_reduce_model

    def initialize(mrm, options = {})
      if mrm.is_a?(Marbu::Models::MapReduceFinalize)
        @map_reduce_model = mrm
      elsif mrm.is_a?(Hash)
        @map_reduce_model = Marbu::Models::MapReduceFinalize.new(mrm)
      else
        raise Exception.new("Parameter mrm was neither of type MapReduceFinalize nor Hash, but #{mrm.class}. Aborting")
      end

      @builder_clasz    = options[:builder] || Marbu::Builder::Mongodb
      @formatter_clasz  = options[:formatter] || Marbu::Formatter::Dummy
    end

    def map(format = :text)
      @formatter_clasz.perform(@builder_clasz.map(@map_reduce_model.map, format))
    end

    def reduce(format = :text)
      @formatter_clasz.perform(@builder_clasz.reduce(@map_reduce_model.reduce, format))
    end

    def finalize(format = :text)
      @formatter_clasz.perform(@builder_clasz.finalize(@map_reduce_model.finalize, format))
    end

    def query(format = :text)
      #@builder_clasz.query(@map_reduce_model.query, format)
      @map_reduce_model.query.static
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
