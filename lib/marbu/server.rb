require 'sinatra/base'
require 'haml'
require 'time'
require 'marbu'
require 'uuid'

module Marbu
  class Server < Sinatra::Base
    logger = ::File.open("log/development.log", "a")
    STDOUT.reopen(logger)
    STDERR.reopen(logger)

    dir = File.dirname(File.expand_path(__FILE__))
    set :views, "#{dir}/server/views"
    set :public_folder, "#{dir}/server/public"
    set :static, true
    set :logging, STDERR

    helpers do
      def url_path(*path_parts)
        [ path_prefix, path_parts ].join("/").squeeze('/')
      end
      alias_method :u, :url_path

      def path_prefix
        request.env['SCRIPT_NAME']
      end
    end

    # stored map reduce finalize objects
    get "/" do
      @mrfs = Marbu::Models::Db::MongoDb.all
      show 'root'
    end

    get "/builder/:uuid" do
      logger.puts("uuid: #{params['uuid']}")
      logger.flush
      
      @mrf = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @mrm        = @mrf.map_reduce_finalize
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    post "/builder/:uuid" do
      @mrf                  = get_mrf(params)
      @mrf.save!

      @mrm        = @mrf.map_reduce_finalize
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    put "/builder" do
      
    end

    get "/result/:uuid" do
      mrf                 = Marbu::Models::Db::MongoDb.find(uuid: params['uuid'])
      mrm                 = mrf.map_reduce_finalize
      builder             = Marbu::Builder.new(mrm)

      @res = Marbu.collection.map_reduce(
                              builder.map,
                              builder.reduce,
                              {
                                :query  => builder.query,
                                :out    => {:replace => "tmp."+mrm.mr_collection}#,
                                #:finalize => builder.finalize
                              }
                          )
      show 'mr'
    end

    def get_mrf(params)
      uuid  = params.delete('uuid') || UUID.new.generate(:compact)
      mrf   = Marbu::Models::Db::MongoDb.find_or_create_by(uuid: uuid)

      name                  = 'name'
      function              = 'function'
      
      mrm                   = Marbu::Models::MapReduceFinalize.new(
                                  :database           => params.delete('database'),
                                  :base_collection    => params.delete('base_collection'),
                                  :mr_collection      => params.delete('mr_collection')
                              )

      map                   = Marbu::Models::Map.new(:code => params.delete('map_code'))
      reduce                = Marbu::Models::Reduce.new(:code => params.delete('reduce_code'))
      finalize              = Marbu::Models::Finalize.new(:code => params.delete('finalize_code'))

      mrm.map               = map
      mrm.reduce            = reduce
      mrm.finalize          = finalize

      ['map', 'finalize'].each do |stage|
        ['key', 'value'].each do |type|
          stage_type_name      = "#{stage}_#{type}_#{name}"
          stage_type_function  = "#{stage}_#{type}_#{function}"

          params[stage_type_name].each_with_index do |n, i|
            case stage
              when 'map'        then
                add(map, type, n, params[stage_type_function][i])
                # TODO: for now there is no difference between map and reduce emit-keys and emit-values. And most likely there shouldn't be one, but we'll see
                add(reduce, type, n, params[stage_type_function][i])
              when 'finalize'   then add(finalize, type, n, params[stage_type_function][i])
              else raise Exception.new("#{stage} in #{k} is unknown")
            end
          end
        end
      end

      mrf.map_reduce_finalize   = mrm
      mrf.name                  = (params.delete('name') || mrf.name) || "NoName"

      return mrf
    end
    
    def add(model, type, name, function)
      case type
        when 'key'      then model.add_key(name, function)
        when 'value'    then model.add_value(name, function)
        else raise Exception.new("#{type} is unknown")
      end
    end

    def show(page)
      haml page.to_sym
    end
  end
end
