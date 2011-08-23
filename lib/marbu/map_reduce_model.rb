module Marbu
  # represents one complete MapReduce-Model
  # this model can be stored in a database and read again
  # the builder will use MapReduce-Models to build actual mapreduce code
  class MapReduceModel
    attr_accessor :map, :reduce, :finalize, :query, :force_query, :database, :base_collection
    attr_accessor :mr_collection

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

        @map = MapModel.new(
            :keys         => mapreduce_keys,
            :values       => mapreduce_values,
            :code         => cloned_params.delete(:map) || cloned_params.delete("map")
        )

        @reduce = ReduceModel.new(
            :keys         => mapreduce_keys,
            :values       => mapreduce_values,
            :code         => cloned_params.delete(:reduce) || cloned_params.delete("reduce")
        )

        @finalize = FinalizeModel.new(
            :keys         => mapreduce_keys,
            :values       => cloned_params.delete(:finalize_values) || cloned_params.delete("finalize_values"),
            :code         => cloned_params.delete(:finalize) || cloned_params.delete("finalize")
        )


        # initialize remaining object variables
        cloned_params.keys.each do |k|
          send("#{k}=".to_sym, params[k]) if respond_to?(k.to_sym)
        end
      end
    end

    def hash
      {
          :mapreduce_keys             => @map.hash[:keys],
          :mapreduce_values           => @reduce.hash[:values],
          :finalize_values            => @finalize.hash[:values],
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
      hash == other.hash
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

    class BaseModel
      attr_accessor :keys, :values
      attr_accessor :code

      def initialize(ext_options = nil)
        @keys           = []
        @values         = []
        @code           = nil

        if ext_options
          int_options     = ext_options
          @keys           = int_options[:keys].map{|k| Key.new(k) }
          @values         = int_options[:values].map{|v| Value.new(v) }
          @code           = int_options[:code]
        end
      end

      def hash
        {
            :keys       => @keys.collect(&:hash),
            :values     => @values.collect(&:hash),
            :code       => @code
        }
      end

      def add_key(name, function)
        add(:key, name, function)
      end

      def add_value(name, function)
        add(:value, name, function)
      end

      private
        def add(type, name, function)
          case type
            when :key     then @keys << Key.new({:name => name, :function => function})
            when :value   then @values << Value.new({:name => name, :function => function})
          end
        end
    end

    class MapModel < BaseModel
    end

    class ReduceModel < BaseModel
    end

    class FinalizeModel < BaseModel
    end

    class KeyValueBase
      attr_accessor :name, :function

      def initialize(params)
        params.keys.each do |k|
          send("#{k}=".to_sym, params[k]) if respond_to?(k)
        end
      end

      def hash
        # don't return nil values in hash
        {
            :name       => @name,
            :function   => @function
        }.keep_if{|k,v| v}
      end
    end

    class Key < KeyValueBase
    end

    class Value < KeyValueBase
    end
  end
end