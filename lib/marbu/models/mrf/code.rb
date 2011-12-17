module Marbu
  module Models
    class Code
      attr_accessor :text, :type

      JS            = "JS"

      def initialize( ext_params = {} )
        params              = default_params.merge( ext_params.keep_if{|k,v|v} )
        @text               = params[:text]
        @type               = params[:type]
      end

      def default_params
        {
          :type       => JS
        }
      end

      def serializable_hash
        {
          :text       => text,
          :type       => type
        }.delete_if{|k,v|v.blank?}
      end

      def present?
        text.present?
      end
    end
  end
end
