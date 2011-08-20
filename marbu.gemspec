# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "marbu/version"

Gem::Specification.new do |s|
  s.name        = "marbu"
  s.version     = Marbu::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["TODO: Write your name"]
  s.email       = ["TODO: Write your email address"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "marbu"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_dependency('rake')
  s.add_dependency "vegas"
  s.add_dependency "sinatra"
  s.add_dependency "haml"
  
  s.add_development_dependency('shoulda')
  s.add_development_dependency('spork')
  s.add_development_dependency('spork-testunit')
end
