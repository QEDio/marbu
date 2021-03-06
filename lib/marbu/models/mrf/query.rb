# -*- encoding: utf-8 -*-

module Marbu
  module Models
    class Query
      DEFAULT_DATE_FIELDS = [:created_at]

      attr_accessor :condition, :datetime_fields, :static

      def initialize( ext_params = {} )
        params                  = default_params.merge( ext_params.keep_if{|k,v|v} )
        @condition              = params[:condition]
        @datetime_fields        = params[:datetime_fields]
        @static                 = params[:static]
      end

      def default_params
        {
          datetime_fields:      DEFAULT_DATE_FIELDS
        }
      end

      def present?
        condition.present? || !datetime_fields.eql?(DEFAULT_DATE_FIELDS) || static.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          condition:            condition,
          datetime_fields:      datetime_fields,
          static:               static
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end