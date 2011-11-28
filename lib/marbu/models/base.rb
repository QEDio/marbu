module Marbu
  module Models
    class Base
      attr_accessor :keys, :values
      attr_accessor :code

      def initialize(ext_options = nil)
        @keys           = []
        @values         = []
        @code           = nil

        if ext_options
          int_options     = ext_options
          @keys           = int_options[:keys].map{|k| Key.new(k) } if int_options[:keys]
          @values         = int_options[:values].map{|v| Value.new(v) } if int_options[:values]
          @code           = int_options[:code]
        end
      end

      def serializable_hash
        {
          :keys       => @keys.collect(&:serializable_hash),
          :values     => @values.collect(&:serializable_hash),
          :code       => @code
        }
      end

      def add_key(name, function = nil)
        add(:key, name, function)
      end

      def add_value(name, function = nil)
        add(:value, name, function)
      end

      private
        def add(type, name, function)
          function = MapReduceFinalize::VALUE_STR + '.' + name.to_s unless function
          case type
            when :key     then @keys << Key.new({:name => name, :function => function})
            when :value   then @values << Value.new({:name => name, :function => function})
          end
        end
    end

    class KeyValueBase
      attr_accessor :name, :function

      def initialize(params)
        params.keys.each do |k|
          send("#{k}=".to_sym, params[k]) if respond_to?(k)
        end
      end

      def name=(name)
        @name = name.to_s
      end

      def serializable_hash
        # don't return nil values in hash
        {
            :name       => @name,
            :function   => @function
        }.keep_if{|k,v| v}
      end
    end

    class Key < KeyValueBase
    end

    class Value < KeyValueBase
    end
  end
end
