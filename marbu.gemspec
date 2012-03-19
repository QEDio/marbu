# -*- encoding: utf-8 -*-

#$:.push File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift 'lib'
require "marbu/version"

Gem::Specification.new do |s|
  s.name        = "marbu"
  s.version     = Marbu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Johannes Kaefer"]
  s.email       = ["jak4@qed.io"]
  s.homepage    = ""
  s.summary     = %q{MA(p) R(educe) BU(ilder)}
  s.description = %q{Integrate fancy MapReduce Bulding functionality with one gem install}

  s.files             = %w( Readme.md Rakefile )
  s.files             += Dir.glob("lib/*")
  s.files             += Dir.glob("bin/*")
  s.executables       = [ "marbu-web" ]

  #s.files         = `git ls-files`.split("\n")
  #s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'vegas'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'sinatra-contrib'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'mongo'
  s.add_runtime_dependency 'mongoid'
  s.add_runtime_dependency 'bson_ext'
  s.add_runtime_dependency 'uuid'
end
