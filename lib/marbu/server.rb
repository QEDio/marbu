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

    get "/" do
      @mrms = Marbu::Models::Db::MongoDb.all
      show 'root'
    end

    get "/builder/new" do
      @mrm              = Marbu::Models::Db::MongoDb.new
      @mrf              = @mrm.map_reduce_finalize
      show 'builder'
    end


    post "/builder" do
      @mrm                  = build_mrm_from_params(params.merge({:logger => logger}))
      @mrm.save!
      redirect "/builder/#{@mrm.uuid}"
    end

    get "/builder/:uuid" do
      @mrm        = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @mrf        = @mrm.map_reduce_finalize
      show 'builder'
    end

    put "/builder/:uuid" do
      @mrm                  = build_mrm_from_params(params.merge({:logger => logger}))
      @mrm.save!
      redirect "/builder/#{@mrm.uuid}"
    end

    delete "/builder/:uuid" do
      @mrm = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @mrm.destroy if( @mrm.present? )

      redirect "/"
    end

    get "/mapreduce/:uuid" do
      @mrf         = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
      @builder     = Marbu::Builder.new(@mrf.map_reduce_finalize)
      @error      = nil

      begin
        # TODO: naturally this has to take the DATABASE and COLLECTION from the mapreducefilter object
        # TODO: don;t take the parameters from the mapreducefilter object if DATABASE or DATABASE and COLLECTION are
        # TODo: defined in the configuration (security)
        @res = Marbu.collection.map_reduce( @builder.map, @builder.reduce,
          {
            :query  => @builder.query,
            :out    => {:replace => "tmp."+@mrf.map_reduce_finalize.misc.output_collection}#,
            #:finalize => builder.finalize
          }
        )
      rescue Mongo::OperationFailure => e
        @error = Marbu::Models::Db::MongoDb::Exception.explain(e)
      end

      show 'mapreduce'
    end

    def build_mrm_from_params(params)
      name                      = 'name'
      function                  = 'function'

      uuid                      = params['uuid']
      if uuid
        mrm                       = Marbu::Models::Db::MongoDb.find_or_create_by(uuid: uuid)
      else
        mrm = Marbu::Models::Db::MongoDb.new
      end

      mrf                       = mrm.map_reduce_finalize

      map_new                   = Marbu::Models::Map.new(
                                      :code => {:text => params['map_code']}
                                    )
      reduce_new                = Marbu::Models::Reduce.new(
                                      :code => {:text => params['reduce_code']}
                                    )
      finalize_new              = Marbu::Models::Finalize.new(
                                      :code => {:text => params['finalize_code']}
                                    )
      query_new                 = Marbu::Models::Query.new(
                                        :condition    => params['query_condition'],
                                        :force_query  => params['query_force_query']
                                    )
      misc_new                  = Marbu::Models::Misc.new(
                                        :database           => params['database'],
                                        :input_collection   => params['input_collection'],
                                        :output_collection  => params['output_collection']
                                    )

      # add params to map_new, reduce_new, finalize_new
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
                when 'finalize'   then add(finalize_new, type, n, stage_type_function[i])
                else raise Exception.new("#{stage} in #{k} is unknown")
              end
            end
          end
        end
      end

      mrf.map               = map_new if map_new.present?

      reduce_new.keys       = mrf.map.keys
      reduce_new.values     = mrf.map.values
      mrf.reduce            = reduce_new if reduce_new.present?

      finalize_new.keys     = mrf.map.keys
      mrf.finalize          = finalize_new if finalize_new.present?

      mrf.query             = query_new if query_new.present?
      mrf.misc              = misc_new if misc_new.present?

      mrm.map_reduce_finalize   = mrf
      mrm.name                  = params['name'] if params['name'].present?

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
