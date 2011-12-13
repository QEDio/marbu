module Marbu
  module Models
    class Query
      DEFAULT_DATE_FIELDS = [:created_at]

      attr_accessor :condition, :datetime_fields


      def initialize( ext_params = {} )
        params                  = default_params.merge( ext_params.keep_if{|k,v|v} )
        @condition              = params[:condition]
        @datetime_fields        = params[:datetime_fields]
      end

      def default_params
        {
          :datetime_fields      => DEFAULT_DATE_FIELDS
        }
      end

      def present?
        condition.present? || datetime_fields.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          :condition              => condition,
          :datetime_fields        => datetime_fields
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end