module Marbu
  module Models
    module Db
      class MongoDb
        class Exception < StandardError
          QUERY_ERROR           =  136081
          QUERY_ERROR_ID        = 'QUERY_ERROR'
          MAP_COMPILE_ERROR     = 13598
          MAP_COMPILE_ERROR_ID  = 'MAP_COMPILE_ERROR'

          def self.explain(e, mrf)
            parsed_exception = parse(e)

            case parsed_exception[:assertion_code]
              when QUERY_ERROR              then { id: QUERY_ERROR_ID, message: explain_query_error(parsed_exception, mrf)}
              when MAP_COMPILE_ERROR        then { id: MAP_COMPILE_ERROR_ID, message: explain_map_compile_error(parsed_exception, mrf)}

              else raise Exception.new("The Error '#{e.to_s}' is unknown to me. Parsed: #{parsed_exception.inspect}")
            end
          end

          def self.parse(e)
            parsed_exception = {}

            parsed_exception[:orig_error]       = e.to_s
            parsed_exception[:assertion]        = e.result['assertion']
            parsed_exception[:assertion_code]   = e.result['assertionCode']
            parsed_exception[:error_code]       = e.error_code
            parsed_exception[:errmsg]           = e.result['errmsg']

            parsed_exception
          end

          def self.explain_ns_error( parsed_exception, mrf )
            "Either the database #{mrf.misc.database} or the collection #{mrf.misc.input_collection} is unknown."
          end

          def self.explain_reference_error( parsed_exception, mrf )
            "The variable #{parsed_exception[:variable]} defined in function #{parsed_exception[:function]} is unknown. This either means you are trying to access a datafield that doesn't exist in the collection, or you misspelled a variable name."
          end

          def self.explain_query_error( parsed_exception, mrf )
            "The Query you supplied doesn't work as you excpected. Query: #{mrf.query.static}."
          end

          def self.explain_map_compile_error( parsed_exception, mrf )
            "Your provided Map-Code couldn't be compiled by MongoDB. Please have a look at your javascript and the input/output variables."
          end
        end
      end
    end
  end
end