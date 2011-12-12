module Marbu
  module Models
    class Query
      attr_accessor :condition, :force_query, :time_params

      def initialize( ext_params = {} )
        params        = default_params.merge( ext_params.keep_if{|k,v|v} )
        @condition    = params[:condition]
        @force_query  = params[:force_query]
        @time_params  = params[:time_params]
      end

      def default_params
        {
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
          :condition        => condition,
          :force_query      => force_query,
          :time_params      => time_params
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end