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


  def database=(database = "marbu")
    @database = database
  end

  def collection=(collection = "mr")
    @collection = collection
  end

  def port=(port = 27017)
    @port = port
  end

  def uri=(uri = "127.0.0.1")
    @uri = uri
  end

  def connection
    @connection ||= Mongo::Connection.new(@uri, @port)
  end

  def database
    connection.db(@database)
  end

  def collection
    database.collection(@collection)
  end
end


