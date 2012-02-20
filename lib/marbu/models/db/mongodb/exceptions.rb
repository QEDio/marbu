module Marbu
  module Models
    module Db
      class MongoDb
        class Exception < StandardError
          REFERENCE_ERROR       = 'ReferenceError'
          NS_ERROR              = 'NS_ERROR'
          REGEX_DB_COMMAND = { :regex => /(ns doesn't exist)/,
                              :mapping => { :function         => {:type => :string, :value => 'Buu'},
                                            :error_type       => {:type => :string, :value => NS_ERROR},
                                            :variable         => {:type => :string, :value => 'Buu'},
                                            :assertion_code   => {:type => :string, :value => 'Buu'},
                                            :error_message    => {:type => :string, :value => 'Buu'} }}
          #REGEX_REF_ERROR = { :regex => /(.*?)'(.*?)'(.*?): \((assertion): '(.*?) (.*?): (.*?): (ReferenceError): (.*?)(is.*?)(nofile_b)?:\d'; (assertionCode): '(.*)';.*(errmsg): '(.*?)'/,
          #                    mapping => { :function => 5, :error_type => 8, :variable => 9, :assertion_code => 13, :error_message => 15 }}}
          REGEXS = [ REGEX_DB_COMMAND ]

          def self.explain(e, mrf)
            parsed_exception = parse(e)

            case parsed_exception[:error_type]
              when REFERENCE_ERROR  then explain_reference_error(parsed_exception, mrf)
              when NS_ERROR         then { :id => NS_ERROR, :message => explain_ns_error(parsed_exception, mrf)}

              else raise Exception.new("The Error #{e.to_s} is unknown to me. Parsed: #{parsed_exception.inspect}")
            end
          end

          def self.parse(e)
            {}.tap do |parsed_exception|
              # http://rubular.com/r/MYM9ADhz4Z
              REGEXS.each do |regex|
                e.result["errmsg"] =~ regex[:regex]
                if( $1.present? )
                  parsed_exception[:orig_error] = e
                  [:function, :error_type, :variable, :assertion_code, :error_message].each do |key|
                    case regex[:mapping][key][:type]
                      when :string then parsed_exception[key]           = regex[:mapping][key][:value]
                      else "Unknown type: #{regex[:mapping][key][:type]}"
                    end
                  end
                  break
                end
              end
            end
          end

          def self.explain_ns_error( parsed_exception, mrf )
            "Either the database #{mrf.misc.database} or the collection #{mrf.misc.input_collection} is unknown."
          end

          def self.explain_reference_error( parsed_exception, mrf )
            "The variable #{parsed_exception[:variable]} defined in function #{parsed_exception[:function]} is unknown. This either means you are trying to access a datafield that doesn't exist in the collection, or you misspelled a variable name."
          end
        end
      end
    end
  end
end