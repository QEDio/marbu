module Marbu
  module Models
    class ExceptionLink
      def self.get_exception_fix_link(error, uuid)
        case error
          when 'NS_ERROR' then '#misc'
          when 'QUERY_ERROR' then '#query'
          when 'MAP_COMPILE_ERROR' then '#map'
        end
      end
    end
  end
end