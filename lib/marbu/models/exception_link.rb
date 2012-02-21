module Marbu
  module Models
    class ExceptionLink
      def self.get_exception_fix_link(error, uuid)
        case error
          when 'NS_ERROR' then "/builder/#{uuid}#misc"
        end
      end
    end
  end
end