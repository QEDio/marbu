module Marbu
  class Formatter
    class OneLine < Base
      def self.perform(str)
        str.gsub(/( |\n)/, '')
      end
    end
  end
end