require 'mongoid'

module Marbu
  module Models
    # represents one complete MapReduce-Model
    # this model can be stored in a database and read again
    # the builder will use MapReduce-Models to build actual mapreduce code
    class MapReduceFinalize
      include Mongoid::Fields::Serializable
      attr_reader :map, :reduce, :finalize, :query, :misc

      def initialize(ext_params = {})
        # TODO: deep copy necessary why?
        params = default_params.merge( Marshal.load(Marshal.dump(ext_params)) )

        self.map                = params[:map]
        self.reduce             = params[:reduce]
        self.finalize           = params[:finalize]
        self.query              = params[:query]
        self.misc               = params[:misc]
      end

      def default_params
        {
          :map                => Map.new,
          :reduce             => Reduce.new,
          :finalize           => Finalize.new,
          :query              => Query.new,
          :misc               => Misc.new
        }
      end

      def map=(map)
        @map = general_setter(map, Marbu::Models::Map)
      end

      def reduce=(reduce)
        @reduce = general_setter(reduce, Marbu::Models::Reduce)
      end

      def finalize=(finalize)
        @finalize = general_setter(finalize, Marbu::Models::Finalize)
      end

      def query=(query)
        @query = general_setter(query, Marbu::Models::Query)
      end

      def misc=(misc)
        @misc = general_setter(misc, Marbu::Models::Misc)
      end

      def serializable_hash
        {
          :map                        => map.serializable_hash,
          :reduce                     => reduce.serializable_hash,
          :finalize                   => finalize.serializable_hash,
          :query                      => query.serializable_hash,
          :misc                       => misc.serializable_hash
        }.delete_if{|k,v|v.blank?}
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

      # TODO: please remove after Mongoid gets non-intrusive de/serialization
      def serialize(object)
        object.serializable_hash
      end

      def deserialize(object)
        MapReduceFinalize.new(object.symbolize_keys_rec)
      end

      private
        def general_setter(var, klass)
          if( var.is_a?(klass) )
            ret_val = var
          elsif( var.is_a?( ::Hash ) )
            ret_val = klass.new(var)
          elsif( var.nil? )
            ret_val = klass.new
          else
            raise Exception.new("Unsupported var type: #{var.class}")
          end

          return ret_val
        end
    end
  end
end