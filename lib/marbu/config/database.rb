module Marbu
  class Database
    attr_accessor :adapter
    
    def initialize( ext_params = {} )
      params          = default_params.merge(ext_params)

      p               = {
        :database     => params.delete(:database),
        :collection   => params.delete(:collection),
        :port         => params.delete(:port),
        :uri          => params.delete(:uri)
      }

      @adapter        = params[:adapter].new(p)
    end

    def default_params
      {
        :adapter        => Marbu::Adapters::Mongodb
      }
    end

    def database=(database)
      adapter.db = database
    end

    def collection=(collection)
      adapter.coll = collection
    end

    def port=(port)
      adapter.port = port
    end

    def uri=(uri)
      adapter.uri = uri
    end

    def connection(ext_options = {})
      options       = default_connection_options.merge(ext_options)

      if( options[:renew] )
        @connection = adapter.connection
      else
        @connection ||= adapter.connection
      end

      return @connection
    end

    def default_connection_options
      {
        :renew        => false
      }
    end

    def database(ext_options = {})
      options         = default_database_options.merge(ext_options)

      if( options[:renew] )
        @database = connection(options).database(options[:database])
      else
        @database ||= connection(options).database(options[:database])
      end

      return @database
    end

    def default_database_options
      {
        :renew        => false
      }
    end

    def collection(ext_options = {})
      options         = default_collection_options(ext_options)

      if( options[:renew] )
        @collection = database()
      end
    end

    def default_collection_options
      {
        :renew        => false
      }
    end
  end
end