require 'marbu/exceptions'
require 'marbu/formatters/base'
require 'marbu/formatters/dummy'
require 'marbu/formatters/one_line'
require 'marbu/builders/mongodb'
require 'marbu/builder'
require 'marbu/shotgun'

require 'marbu/models/models'

require 'mongo'

module Marbu
  # Your code goes here...
  extend self

  attr_reader :port, :uri
  attr_accessor :storage

  def database=(database)
    @database = database
  end

  def collection=(collection)
    @collection = collection
  end

  def port=(port)
    @port = port
  end

  def uri=(uri)
    @uri = uri
  end

  def connection
    if( @uri and @port )
      @connection ||= Mongo::Connection.new(@uri, @port)
    else
      @connection = nil
    end

    @connection
  end

  def database
    if connection and @database
      connection.db(@database)
    else
      nil
    end
  end

  def collection
    if database and @collection
      database.collection(@collection)
    else
      nil
    end
  end

  def storage_collection
    Mongo::Connection.new(storage[:uri],storage[:port]).db(storage[:database]).collection(storage[:collection])
  end
end


