require 'mongoid'

module Marbu
  module Models
    # represents one complete MapReduce-Model
    # this model can be stored in a database and read again
    # the builder will use MapReduce-Models to build actual mapreduce code
    class MapReduceFinalize
      include Mongoid::Fields::Serializable
      attr_accessor :map, :reduce, :finalize, :query, :force_query, :database, :base_collection
      attr_accessor :mr_collection
      VALUE = :value
      VALUE_STR = VALUE.to_s
      DOCUMENT_OFFSET = VALUE.to_s + "."

      def serialize(object)
        object.serializable_hash
      end

      def deserialize(object)
        MapReduceFinalize.new(object)
      end

      def initialize(params = nil)
        @map = nil
        @reduce = nil
        @finalize = nil
        @query = nil
        @force_query  = false
        @database = nil
        @base_collection = nil
        @mr_collection = nil

        if( params )
          # make a deep copy
          cloned_params = Marshal.load(Marshal.dump(params))

          mapreduce_keys    = cloned_params.delete(:mapreduce_keys) || cloned_params.delete("mapreduce_keys")
          mapreduce_values  = cloned_params.delete(:mapreduce_values) || cloned_params.delete("mapreduce_values")

          if( mapreduce_keys && mapreduce_values )
            @map = Map.new(
                :keys         => mapreduce_keys,
                :values       => mapreduce_values,
                :code         => cloned_params.delete(:map) || cloned_params.delete("map")
            )

            @reduce = Reduce.new(
                :keys         => mapreduce_keys,
                :values       => mapreduce_values,
                :code         => cloned_params.delete(:reduce) || cloned_params.delete("reduce")
            )

            @finalize = Finalize.new(
                :keys         => mapreduce_keys,
                :values       => cloned_params.delete(:finalize_values) || cloned_params.delete("finalize_values"),
                :code         => cloned_params.delete(:finalize) || cloned_params.delete("finalize")
            )
          end


          # initialize remaining object variables
          cloned_params.keys.each do |k|
            send("#{k}=".to_sym, params[k]) if respond_to?(k.to_sym)
          end
        end
      end

      def serializable_hash
        {
          :mapreduce_keys             => @map.serializable_hash[:keys],
          :mapreduce_values           => @reduce.serializable_hash[:values],
          :finalize_values            => @finalize.serializable_hash[:values],
          :database                   => @database,
          :base_collection            => @base_collection,
          :mr_collection              => @mr_collection,
          :query                      => @query,
          :map                        => @map.code,
          :reduce                     => @reduce.code,
          :finalize                   => @finalize.code
        }
      end

      # return true if we have a map and a reduce function defined
      def mapreduce?
        !(map.nil? && reduce.nil?)
      end

      def query_only?
        force_query || (!mapreduce? && !query.nil?)
      end

      def eql?(other)
        serializable_hash == other.serializable_hash
      end

      def ==(other)
        eql?(other)
      end

      # sanatize JS in here
      def query=(q)
        @query = q
      end

      def mr_key
        [].tap do |arr|
          # @map.keys should be in the map-reduce-model directly
          @map.keys.each do |mapreduce_key|
            arr << mapreduce_key.name
          end
        end
      end
    end
  end
end