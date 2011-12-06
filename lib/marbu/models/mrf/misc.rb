module Marbu
  module Models
    class Misc
      attr_accessor :database, :input_collection, :output_collection
      attr_accessor :value, :document_offset

      VALUE = :value
      DOCUMENT_OFFSET = VALUE.to_s + "."

      def initialize( ext_params = {} )
        params              = default_params.merge( ext_params.delete_if{|k,v|v.blank?} )

        @database           = params[:database]
        @input_collection   = params[:input_collection]
        @output_collection  = params[:output_collection]
      end

      def default_params
        {
          :value              => VALUE,
          :document_offset    => DOCUMENT_OFFSET
        }
      end

      def present?
        database.present? || input_collection.present? || input_collection.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          :database           => database,
          :input_collection   => input_collection,
          :output_collection  => output_collection
        }.delete_if{|k,v|v.blank?}
      end
    end
  end
end