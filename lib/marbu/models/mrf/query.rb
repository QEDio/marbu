module Marbu
  module Models
    class Query
      attr_accessor :condition, :force_query

      def initialize( ext_params = {} )
        params        = default_params.merge( ext_params.keep_if{|k,v|v} )
        @condition    = params[:condition]
        @force_query  = params[:force_query]
      end

      def default_params
        {
        }
      end

      def present?
        condition.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          :condition        => condition,
          :force_query      => force_query
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end