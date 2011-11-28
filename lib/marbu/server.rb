require 'sinatra/base'
require 'haml'
require 'time'
require 'marbu'

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

    get('/') { redirect '/builder' }
    
    # to make things easier on ourselves
    get "/builder" do
      storage_collection = Marbu.storage_collection

      if storage_collection
        mrm_hsh   = storage_collection.find_one || MR_MONGODB_EXAMPLE
      else
        mrm_hsh   = MR_MONGODB_EXAMPLE
      end

      @mrm        = Marbu::Models::MapReduceFinalize.new(mrm_hsh)
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    post "/builder" do
      @mrm                  = build_mrm(params.merge({:logger => logger}))

      logger.puts(@mrm.serializable_hash.inspect)
      logger.puts("###############################")
      logger.flush



      storage_collection = Marbu.storage_collection
      if( storage_collection )
        storage_collection.insert(@mrm.serializable_hash)
      end

      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    get "/mr" do
      storage_collection  = Marbu.storage_collection
      mrm_hsh             = storage_collection.find_one
      mrm                 = Marbu::Models::MapReduceFinalize.new(mrm_hsh)
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

    def build_mrm(params)
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

      return mrm
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
