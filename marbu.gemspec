# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
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

  s.rubyforge_project = "marbu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency 'rake'
  s.add_runtime_dependency 'vegas'
  s.add_runtime_dependency 'sinatra'
  s.add_runtime_dependency 'haml'
  s.add_runtime_dependency 'mongo'

  s.add_development_dependency 'turn'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'spork'
  s.add_development_dependency 'spork-testunit'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'i18n'
end
