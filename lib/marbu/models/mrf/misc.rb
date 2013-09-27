module Marbu
  module Models
    class Misc
      attr_accessor :database, :input_collection, :output_collection, :output_operation, :id
      # if filter_data is true, a query will be created depending on the filter parameters in filter_model
      # if filter_data is false, no query will generated
      # this is necessary for multiple sequentiell map_reduces: some will work on already filtered data (so no filter needed)
      # while others will grab data from other collections which need to be filtered first
      attr_reader :filter_data
      attr_accessor :value, :document_offset

      VALUE = :value
      DOCUMENT_OFFSET = VALUE.to_s + "."
      ID_OFFSET       = 'id.'

      def initialize( ext_params = {} )
        params              = default_params.merge( ext_params.delete_if{|k,v|v.blank?} )

        self.database           = params[:database]
        self.input_collection   = params[:input_collection]
        self.output_collection  = params[:output_collection]
        self.output_operation   = params[:output_operation]
        self.filter_data        = params[:filter_data]
        self.id                 = params[:id]
      end

      def default_params
        {
          value:              VALUE,
          document_offset:    DOCUMENT_OFFSET,
          filter_data:        false,
          output_operation:   'replace',
          id:                 ''
        }
      end

      def filter_data=(fd)
        if( !!fd == fd )
          @filter_data = fd
        else
          raise Exception.new("Need a boolean value!")
        end
      end

      def present?
        database.present? || input_collection.present? || output_collection.present?
      end

      def blank?
        !present?
      end

      def serializable_hash
        {
          database:           database,
          input_collection:   input_collection,
          output_collection:  output_collection,
          output_operation:   output_operation,
          filter_data:        filter_data,
          id:                 id
        }.delete_if{|k,v|v.blank?}
      end

      def collection
        Marbu.connection.db(database).collection(input_collection)
      end
    end
  end
end