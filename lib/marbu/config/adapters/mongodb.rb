module Marbu
  module Adapters
    class Mongodb
      attr_accessor :db, :coll, :port, :uri

      def initialize( ext_params = {} )
        options     = default_params.merge(ext_params)

        @db          = options[:database]
        @coll        = options[:collection]
        @port        = options[:port]
        @uri         = options[:uri]
      end

      def default_params
        {
          :port     => '27017',
          :uri      => '127.0.0.1'
        }
      end

      def connection
        c = nil

        if( uri && port )
          c = Mongo::Connection.new(uri, port)
        end

        return c
      end

      def database(database = nil)
        db = nil
        d  = database || self.db

        if connection
          connection.db(database)
        end

        return db
      end

      def collection(collection)
        coll = nil

        if database
          coll = self.database.collection(collection)
        end

        return coll
      end
    end
  end
end