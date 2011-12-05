require 'mongoid'
require 'uuid'

module Marbu
  module Models
    module Db
      class MongoDb
        include Mongoid::Document
        store_in :marbu

        field :uuid,                  type: String, :default => lambda{||UUID.new.generate(:compact)}
        field :name,                  type: String, :default => "NoName00"
        field :map_reduce_finalize,   type: MapReduceFinalize
      end
    end
  end
end