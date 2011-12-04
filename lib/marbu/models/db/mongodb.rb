require 'mongoid'

module Marbu
  module Models
    module Db
      class MongoDb
        include Mongoid::Document
        store_in :marbu

        field :uuid,                  type: String
        field :name,                  type: String
        field :map_reduce_finalize,   type: MapReduceFinalize
      end
    end
  end
end