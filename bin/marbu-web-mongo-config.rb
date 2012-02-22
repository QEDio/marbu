require 'mongo'

Marbu.uri             = '127.0.0.1'
Marbu.port            = '27017'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('marbu')
end