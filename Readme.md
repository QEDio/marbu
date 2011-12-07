MA(p) R(educe) BU(ilder)
========================

Marbu enables you to add mapreduce code-generating functionality to your software within seconds.

What does it do?
----------------

Marbu contains three destinct parts

1. The MapReduceFinalize-Model which acts as an Interface for the MapReduceBuilder
2. The map-reduce core functionality: this creates map reduce code for different map reduce systems
3. A Sinatra App which lets you instantly play around with the builder and shows you what you can do.

Installation
-----------------
Install with 'gem install marbu'.

For bundler add "gem 'marbu'" to your Gemfile.

Stand alone usage
-----------------

Marbu comes complete with a little Sinatra App to help you along. You start the app with 'marbu-web marbu-web-mongo-config.rb'.
This will start Marbu with the provided MongoDB-Configuration file.

If everything is working, you can go to 'localhost:5678' (if you are already running something on 5678 then try 5679) and
you should see all databases in your local MongoDB installation.

After selecting a Database you will see all collections within this database. You select a collection and go into the 'marbu' mode.
In the 'marbu' mode you can build your map - reduce - finalize functionality. After that run your query and see what you get. Done!


## Development

Clone the repo

    $ git clone git@github.com:QEDio/qstate.git

Update submodules

    $ git submodule init && git submodule update

Install dependencies

    $ bundle install

Run the tests

    $ bundle exec rpsec spec
