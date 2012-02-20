module Marbu
  module Models
    module Db
      class MongoDb
        class Structure
          def self.get_collection_structure( collection_info )
            raise "collection_info needs to be Marbu::Models::Misc, but is: #{collection_info.class}"


          end
        end
      end
    end
  end
end
