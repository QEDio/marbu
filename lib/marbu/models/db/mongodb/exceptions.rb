module Marbu
  module Models
    module Db
      class MongoDb
        class Exception < StandardError
          REFERENCE_ERROR       = 'ReferenceError'
          REGEX_DB_COMMAND = { :regex => /Database command '(.*?)'(.*?): \(errmsg: '(.+?)';/,
                              :mapping => { :function => 5, :error_type => 8, :variable => 9, :assertion_code => 13, :error_message => 15 }}
          REGEX_REF_ERROR = { :regex => /(.*?)'(.*?)'(.*?): \((assertion): '(.*?) (.*?): (.*?): (ReferenceError): (.*?)(is.*?)(nofile_b)?:\d'; (assertionCode): '(.*)';.*(errmsg): '(.*?)'/,
                              :mapping => {}}
          REGEXS = [ REGEX_DB_COMMAND, REGEX_REF_ERROR ]

          def self.explain(e)
            debugger
            parsed_exception = parse(e)

            case parsed_exception[:error_type]
              when REFERENCE_ERROR then explain_reference_error(parsed_exception)
              else raise Exception.new("The Error #{e.to_s} is unknown to me. Parsed: #{parsed_exception.inspect}")
            end
          end

          def self.parse(e)
            parsed_exception = {}
            # http://rubular.com/r/MYM9ADhz4Z
            regex = /(.*?)'(.*?)'(.*?): \((assertion): '(.*?) (.*?): (.*?): (ReferenceError): (.*?)(is.*?)(nofile_b)?:\d'; (assertionCode): '(.*)';.*(errmsg): '(.*?)'/
              e.result["errmsg"] =~ regex

              parsed_exception[:function]           = $5
              parsed_exception[:error_type]         = $8
              parsed_exception[:variable]           = $9
              parsed_exception[:assertion_code]     = $13
              parsed_exception[:error_message]      = $15

              return parsed_exception
            end
          end

          def self.explain_reference_error( parsed_exception )
            "The variable #{parsed_exception[:variable]} defined in function #{parsed_exception[:function]} is unknown. This either means you are trying to access a datafield that doesn't exist in the collection, or you misspelled a variable name."
          end
        end
      end
    end
  end
end