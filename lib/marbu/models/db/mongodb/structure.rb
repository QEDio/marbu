module Marbu
  module Models
    module Db
      class MongoDb
        class Structure
          def self.get_collection_structure( collection_info )
            raise "collection_info needs to be Marbu::Models::Misc, but is: #{collection_info.class}" unless collection_info.is_a?(Marbu::Models::Misc)

            collection  = collection_info.collection
            document    = collection.find().first()


          end

          private
            def self.get_collection_structure_int(document, structure)
              [].tap do |arr|
                document.each_pair do |key, value|
                  if( value.is_a?(Hash) )
                    arr[key] = get_collection_structure_int(value)
                  else
                    arr[key] = nil
                  end
                end
              end
            end
        end
      end
    end
  end
end
