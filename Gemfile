source "http://rubygems.org"

gem 'mongodb-testdata-factory', :git => 'git@github.com:QEDio/mongodb-testdata-factory.git', :submodules => true

# Specify your gem's dependencies in marbu.gemspec
gemspec

group :test do
  gem 'turn'
  gem 'rspec'
  gem 'spork'
  gem 'spork-testunit'
  gem 'simplecov'
  gem 'factory_girl'
end

group :development do
  gem 'i18n'
  gem 'linecache19', :git => 'git://github.com/mark-moseley/linecache'
  gem 'ruby-debug-base19x', '~> 0.11.30.pre4'
  gem 'ruby-debug19'
  gem 'thin'
end