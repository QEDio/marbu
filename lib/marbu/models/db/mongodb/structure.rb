module Marbu
  module Models
    module Db
      class MongoDb
        class Structure
          def self.get_collection_structure( collection_info )
            raise "collection_info needs to be Marbu::Models::Misc, but is: #{collection_info.class}" unless collection_info.is_a?(Marbu::Models::Misc)

            collection  = collection_info.collection
            document    = collection.find().first()

            get_collection_structure_int(document)
          end

          def self.get_first_and_last_document( collection_info )
            raise "collection_info needs to be Marbu::Models::Misc, but is: #{collection_info.class}" unless collection_info.is_a?(Marbu::Models::Misc)

            collection  = collection_info.collection

            [collection.find().sort([['_id', 1]]).first(), collection.find().sort([['_id', -1]]).first()]
          end


          private
            def self.get_collection_structure_int(document)
              {}.tap do |hsh|
                document.each_pair do |key, value|
                  if( value.is_a?(Hash) )
                    hsh[key] = get_collection_structure_int(value)
                  else
                    hsh[key] = key
                  end
                end
              end
            end
        end
      end
    end
  end
end
