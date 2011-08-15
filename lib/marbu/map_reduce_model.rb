module Marbu
  # represents one complete MapReduce-Model
  # this model can be stored in a database and read again
  # the builder will use MapReduce-Models to build actual mapreduce code
  class MapReduceModel
    attr_accessor :mapreduce_keys, :mapreduce_values, :finalize_values, :force_query
    attr_reader   :map, :reduce, :finalize

    ARRAY_INITS = [:mapreduce_values, :finalize_values]

    def initialize(params = {})
      @mapreduce_keys = []
      @mapreduce_values = []
      @finalize_values = []
      @map = nil
      @reduce = nil
      @finalize = nil
      @query = nil
      @force_query  = false

      params.keys.each do |k|
        # generate key objects
        if k.eql?(:mapreduce_keys) and respond_to?(k)
          params[k].each do |kk|
            # add key object to key attr_accessor
            send("#{k}=".to_sym, send(k.to_sym) << Key.new(kk))
          end
        # generate value objects
        elsif ARRAY_INITS.include?(k) and respond_to?(k)
          params[k].each do |kk|
            # generate and add value object to corresponding attr_accessor
            send("#{k}=".to_sym, send(k.to_sym) << Value.new(kk))
          end
        else
          send("#{k}=".to_sym, params[k]) if respond_to?(k)
        end
      end
    end

    def hash
      {
          :mapreduce_keys             => @mapreduce_keys,
          :mapreduce_values           => @mapreduce_values,
          :finalize_values            => @finalize_values,
          :map                        => @map,
          :reduce                     => @reduce,
          :query                      => @query,
          :force_query                => @force_query
      }
    end

    def eql?(other)
      hash == other.hash
    end

    def ==(other)
      eql?(other)
    end

    # sanatize JS in here
    def map=(m)
      @map = m
    end

    # sanatize JS in here
    def reduce=(r)
      @reduce = r
    end

    # sanatize JS in here
    def finalize=(f)
      @finalize = f
    end

    # sanatize JS in here
    def query=(q)
      @query = q
    end

    class Key
      attr_accessor :name, :function

      def initialize(params = {})
        @name = nil
        @function = nil

        params.keys.each do |k|
          send("#{k}=".to_sym, params[k]) if respond_to?(k)
        end
      end
    end

    class Value
      attr_accessor :name, :function

      def initialize(params = {})
        @name = nil
        @function = nil

        params.keys.each do |k|
          send("#{k}=".to_sym, params[k]) if respond_to?(k)
        end
      end
    end
  end
end