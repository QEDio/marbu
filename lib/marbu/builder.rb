module Marbu
  class Builder
    attr_accessor :map_reduce_model

    def initialize(params = {})
      @map_reduce_model = params[:map_reduce_model]
      @builder_clasz    = params[:builder] || Marbu::Builder::Mongodb
    end

    def mr_key
      [].tap do |arr|
        @map_reduce_model.mapreduce_keys.each do |mapreduce_key|
          arr << mapreduce_key.name
        end
      end
    end

    # return true if we have a map and a reduce function defined
    def mapreduce?
      !(@map_reduce_model.map.nil? && @@map_reduce_model.reduce.nil?)
    end

    def query_only?
      @map_reduce_model.force_query || (!mapreduce? && !@map_reduce_model.query.nil?)
    end

    def map
      @builder_clasz.map(@map_reduce_model.map, @map_reduce_model.mapreduce_keys, @map_reduce_model.mapreduce_values)
    end

    def reduce
      @builder_clasz.reduce(@map_reduce_model.reduce, @map_reduce_model.mapreduce_values)
    end

    def finalize
      @builder_clasz.finalize(@map_reduce_model.finalize, @map_reduce_model.finalize_values)
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
