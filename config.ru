#!/usr/bin/env ruby
require 'logger'

$LOAD_PATH.unshift ::File.expand_path(::File.dirname(__FILE__) + '/lib')
require 'marbu/server'

# Set the MARBUCONFIG env variable if you've a `resque.rb` or similar
# config file you want loaded on boot.
if ENV['MARBUCONFIG'] && ::File.exists?(::File.expand_path(ENV['MARBUCONFIG']))
  load ::File.expand_path(ENV['MARBUCONFIG'])
end

use Rack::ShowExceptions
run Marbu::Server.new
