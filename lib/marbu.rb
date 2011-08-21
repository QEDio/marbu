require 'marbu/formatters/base'
require 'marbu/formatters/dummy'
require 'marbu/formatters/one_line'
require 'marbu/builders/mongodb'
require 'marbu/map_reduce_model'
require 'marbu/builder'
require 'marbu/shotgun'

require 'mongo'

module Marbu
  # Your code goes here...
  extend self


  def database=(database = nil)
    @database = database
  end

  def collection=(collection = nil)
    @collection = collection
  end

  def port=(port = nil)
    @port = port
  end

  def uri=(uri = nil)
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
end


