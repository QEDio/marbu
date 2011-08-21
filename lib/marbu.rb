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

  attr_reader :port, :uri

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
    @uri ||= "127.0.0.1"
    @port = 27017
    @connection ||= Mongo::Connection.new(@uri, @port)
  end

  def database
    @database ||= "marbu"
    connection.db(@database)
  end

  def collection
    @collection ||= "mr"
    database.collection(@collection)
  end
end


