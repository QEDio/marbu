module Marbu
  class Formatter
    class Dummy < Base
      def self.perform(str)
        str
      end
    end
  end
end