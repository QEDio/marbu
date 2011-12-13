module Marbu
  module Models
    class Query
      attr_accessor :condition, :force_query, :time_params
      attr_accessor :datetime_mandatory

      def initialize( ext_params = {} )
        params                  = default_params.merge( ext_params.keep_if{|k,v|v} )
        @condition              = params[:condition]
        @force_query            = params[:force_query]
        @time_params            = params[:time_params]
        @datetime_mandatory     = params[:datetime_mandatory]
      end

      def default_params
        {
          :datetime_mandatory       => false
        }
      end

      def present?
        condition.present? || time_params.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          :condition              => condition,
          :force_query            => force_query,
          :time_params            => time_params,
          :datetime_mandatory     => datetime_mandatory
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end