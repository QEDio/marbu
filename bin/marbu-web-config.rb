require 'mongo'

Marbu.database        = 'kp'
Marbu.collection      = 'adwords_early_warning_staging'
Marbu.uri             = '127.0.0.1'
Marbu.port            = '27017'

Marbu.storage         = {:database => 'kp', :collection => 'marbu', :uri => '127.0.0.1', :port => '27017'}