module Marbu
  module Models
    class Base
      attr_accessor :keys, :values, :options
      attr_reader :code

      def initialize(ext_options = {})
        # keep_if weeds out nil arguments
        options         = default_options.merge( ext_options.keep_if{|k,v| v} )
        
        @keys           = options[:keys].map{ |k| Key.new(k) }
        @values         = options[:values].map{ |v| Value.new(v) }
        @options        = options[:options]
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
          func = get_function(type, name, function)

          case type
            when :key     then @keys << Key.new({:name => name, :function => func})
            when :value   then @values << Value.new({:name => name, :function => func})
          end
        end

        # create (var || value.var) or
        # (var || id.var)

        def get_function(type, name, function)
          func            = function

          unless function
            func = case type
              when :key then "(#{Misc::DOCUMENT_OFFSET}#{name} || #{Misc::ID_OFFSET}#{name})"
              when :value then "(#{name} || #{Misc::DOCUMENT_OFFSET}#{name})"
            end
          end

          return func
        end
    end

    class KeyValueBase
      attr_accessor :name, :function

      def initialize(params)
        #params.keys.each do |k|
        #  send("#{k}=".to_sym, params[k]) if respond_to?(k)
        #end

        self.name       = params[:name]
        self.function   = params[:function]
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

      def to_s
        name
      end
    end

    class Key < KeyValueBase
      attr_reader :exchangeable

      def initialize( ext_options = {} )
        options             = default_options.merge( ext_options.delete_if{|k,v|v.nil?} )

        self.exchangeable   = options.delete(:exchangeable)
        super(options)
      end

      def default_options
        {
          :exchangeable        => true
        }
      end

      def exchangeable=(e)
        # make sure it's a boolean
        if( !!e == e )
          @exchangeable = e
        else
          raise Exception.new("Hey, I need a boolean!")
        end

        return self
      end

    end

    class Value < KeyValueBase
    end
  end
end
