module Marbu
  module Models
    class Base
      attr_accessor :keys, :values
      attr_reader :code

      def initialize(ext_options = {})
        # keep_if weeds out nil arguments
        options         = default_options.merge( ext_options.keep_if{|k,v| v} )
        
        @keys           = options[:keys].map{ |k| Key.new(k) }
        @values         = options[:values].map{ |v| Value.new(v) }
        self.code       = options[:code]
      end

      def default_options
        {
          :keys             => [],
          :values           => [],
          :code             => Code.new
        }
      end

      def code=(code)
        if( code.is_a?(Code) )
          @code = code
        elsif( code.is_a?(Hash) )
          @code = Code.new(code)
        else
          raise Exception.new("Don't know this Code type: #{code.class}")
        end
      end

      def serializable_hash
        {
          :keys       => keys.collect(&:serializable_hash),
          :values     => values.collect(&:serializable_hash),
          :code       => code.serializable_hash
        }.delete_if{|k,v|v.blank?}
      end

      def add_key(name, function = nil)
        add(:key, name, function)
      end

      def add_value(name, function = nil)
        add(:value, name, function)
      end

      def present?
        @keys.present? || code.present?
      end

      def blank?
        !present?
      end

      private
        def add(type, name, function)
          function = Misc::DOCUMENT_OFFSET + name.to_s unless function
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

      def present?
        name.present? && function.present?
      end

      def blank?
        !present?
      end
    end

    class Key < KeyValueBase
    end

    class Value < KeyValueBase
    end
  end
end
