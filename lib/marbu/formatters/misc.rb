module Marbu
  class Formatter
    class Misc
      def self.one_line(str)
        str.gsub(/( |\n)/, '')
      end
    end
  end
end