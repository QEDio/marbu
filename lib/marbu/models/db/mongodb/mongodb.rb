require 'mongoid'
require 'uuid'

module Marbu
  module Models
    module Db
      class MongoDb
        include Mongoid::Document
        store_in :marbu

        field :uuid,                  type: String
        field :name,                  type: String
        field :map_reduce_finalize,   type: MapReduceFinalize

        def initialize( ext_params = {} )
          super
          params                    = default_params.merge( ext_params.delete_if{|k,v| v.blank? })

          self.uuid                 = params[:uuid]
          self.name                 = params[:name]
          self.map_reduce_finalize  = MapReduceFinalize.new( params[:map_reduce_finalize] )
        end

        def default_params
          {
            :name                 => "NoName00",
            :uuid                 => UUID.new.generate(:compact),
            :map_reduce_finalize => {
              :map => {
                :keys => [{:name => "map_key1"}],
                :values => [{:name => "map_value1"}]
              },
              :finalize => {
                :values => [{:name => "finalize"}]
              },
              :misc => {
                :database           => 'database',
                :input_collection   => 'input_collection',
                :output_collection  => 'output_collection'
              }
            }
          }
        end
      end
    end
  end
end