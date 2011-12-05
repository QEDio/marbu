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

    delete "/builder/:uuid" do
      @mrf = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})

      logger.puts @mrf.inspect
      logger.flush
      
      @mrf.destroy if( @mrf.present? )


      redirect "/"
    end

    get "/builder/new" do
      @mrf              = Marbu::Models::Db::MongoDb.new
      mrm               = Marbu::Models::MapReduceFinalize.new(
                            :database           => 'database',
                            :base_collection    => 'base_collection',
                            :mr_collection      => 'mr_collection'
                        )


      map               = Marbu::Models::Map.new(:keys => [{:name => "map_key1"}], :values => [{:name => "map_value1"}])
      reduce            = Marbu::Models::Reduce.new
      finalize          = Marbu::Models::Finalize.new(:values => [{:name => "finalize"}])

      mrm.map           = map
      mrm.reduce        = reduce
      mrm.finalize      = finalize

      @mrf.map_reduce_finalize = mrm

      @mrf.save!

      redirect "builder/#{@mrf.uuid}"
    end

    get "/builder/:uuid/:type" do
      @mrf        = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @mrm        = @mrf.map_reduce_finalize
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}


      @cols       = {'map' => @map, 'reduce' => @reduce, 'finalize' => @finalize}
      @mr_step    = @cols[params[:type]]

      haml :builder_col
    end

    get "/builder/:uuid" do
      @mrf        = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @mrm        = @mrf.map_reduce_finalize
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    post "/builder/:uuid" do
      @mrf                  = get_mrf(params.merge({:logger => logger}))
      @mrf.save!

      @mrm        = @mrf.map_reduce_finalize
      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    get "/mapreduce/:uuid" do
      @mrf         = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @builder     = Marbu::Builder.new(@mrf.map_reduce_finalize)
      @error      = nil

      begin
        @res = Marbu.collection.map_reduce( @builder.map, @builder.reduce,
          {
            :query  => @builder.query,
            :out    => {:replace => "tmp."+@mrf.map_reduce_finalize.mr_collection}#,
            #:finalize => builder.finalize
          }
        )
      rescue Mongo::OperationFailure => e
        @error = Marbu::Models::Db::MongoDbException.explain(e)
      end
      
      show 'mapreduce'
    end

    def get_mrf(params)
      name                  = 'name'
      function              = 'function'

      uuid  = params.delete('uuid')
      raise Exception.new("No uuid!") if uuid.blank?

      mrf   = Marbu::Models::Db::MongoDb.find_or_create_by(uuid: uuid)
      mrm                   = mrf.map_reduce_finalize

      map_new                   = Marbu::Models::Map.new(:code => params.delete('map_code'))
      reduce_new                = Marbu::Models::Reduce.new(:code => params.delete('reduce_code'))
      finalize_new              = Marbu::Models::Finalize.new(:code => params.delete('finalize_code'))

      params[:logger].puts(params.inspect)
      params[:logger].flush

      ['map', 'finalize'].each do |stage|
        ['key', 'value'].each do |type|
          stage_type_name       = params["#{stage}_#{type}_#{name}"]
          stage_type_function   = params["#{stage}_#{type}_#{function}"]

          if( stage_type_name.present?)
            stage_type_name.each_with_index do |n, i|
              case stage
                when 'map'        then
                  add(map_new, type, n, stage_type_function[i])
                  # TODO: for now there is no difference between map and reduce emit-keys and emit-values. And most likely there shouldn't be one, but we'll see
                  add(reduce_new, type, n, stage_type_function[i])
                when 'finalize'   then add(finalize, type, n, stage_type_function[i])
                else raise Exception.new("#{stage} in #{k} is unknown")
              end
            end
          end
        end
      end

      mrm.map               = map_new if( map_new.present? )
      mrm.reduce            = reduce_new if( reduce_new.present? )
      mrm.finalize          = finalize_new if( finalize_new.present? )

      mrm.database          = params['database'] if params['database'].present?
      mrm.mr_collection     = params['mr_collection'] if params['mr_collection'].present?
      mrm.base_collection   = params['base_collection'] if params['base_collection'].present?

      mrf.map_reduce_finalize   = mrm
      mrf.name                  = params['name'] if params['name'].present?

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
