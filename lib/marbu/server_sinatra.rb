# -*- encoding: utf-8 -*-

require 'sinatra'
require 'marbu'
Marbu.port = '27017'
Marbu.uri = '127.0.0.1'

Mongoid.configure do |config|
  config.master = Mongo::Connection.new.db('marbu')
end

configure :development do
  require 'ruby-debug'
  enable :logging, :dump_errors, :raise_errors,
end

enable :method_override

dir = File.dirname(File.expand_path(__FILE__))
set :views, "#{dir}/server/views"
set :public_folder, "#{dir}/server/public"
set :static, true

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
  @mrm.destroy if @mrm.present?
  redirect "/"
end

get "/mapreduce/:uuid" do
  @mrm         = Marbu::Models::Db::MongoDb.first(conditions: {uuid: params['uuid']})
  @mrf         = @mrm.map_reduce_finalize
  @builder     = Marbu::Builder.new(@mrf)
  @error      = nil

  begin
    # TODO: naturally this has to take the DATABASE and COLLECTION from the mapreducefilter object
    # TODO: don;t take the parameters from the mapreducefilter object if DATABASE or DATABASE and COLLECTION are
    # TODo: defined in the configuration (security)
    @res = @mrf.misc.collection.map_reduce( @builder.map(:mongodb), @builder.reduce(:mongodb),
                                            {
                                                :query  => @builder.query,
                                                :out    => {:replace => "tmp."+@mrm.map_reduce_finalize.misc.output_collection},
                                                :finalize => @builder.finalize(:mongodb)
                                            }
    )
  rescue Mongo::OperationFailure => e
    @parsed_error = Marbu::Models::Db::MongoDb::Exception.explain(e, @mrf)
    @error        = @parsed_error[:message]
    @fix_link     = Marbu::Models::ExceptionLink.get_exception_fix_link(@parsed_error[:id], params['uuid'])
  end

  show 'mapreduce'
end

def build_mrm_from_params(params)
  name                      = 'name'
  function                  = 'function'

  if (uuid = params['uuid'])
    mrm                       = Marbu::Models::Db::MongoDb.find_or_create_by(uuid: uuid)
  else
    mrm = Marbu::Models::Db::MongoDb.new
  end
  mrm.name                  = params['name']
  mrf                       = mrm.map_reduce_finalize

  mrf.map                   = Marbu::Models::Map.new(
      :code => {:text => params['map_code']}
  )
  mrf.reduce                = Marbu::Models::Reduce.new(
      :code => {:text => params['reduce_code']}
  )
  mrf.finalize              = Marbu::Models::Finalize.new(
      :code => {:text => params['finalize_code']}
  )
  mrf.query                 = Marbu::Models::Query.new(
      :condition    => params['query_condition'],
      :force_query  => params['query_force_query']
  )
  mrf.misc                  = Marbu::Models::Misc.new(
      :database           => params['database'],
      :input_collection   => params['input_collection'],
      :output_collection  => params['output_collection']
  )

  # add params to map_new, reduce_new, finalize_new
  ['map', 'reduce', 'finalize'].each do |stage|
    ['key', 'value'].each do |type|
      stage_type_name       = params["#{stage}_#{type}_#{name}"]
      stage_type_function   = params["#{stage}_#{type}_#{function}"]

      if( stage_type_name.present?)
        stage_type_name.each_with_index do |n, i|
          case stage
            when 'map'      then add(mrf.map, type, n, stage_type_function[i])
            when 'reduce'   then add(mrf.reduce, type, n, stage_type_function[i])
            when 'finalize' then add(mrf.finalize, type, n, stage_type_function[i])
            else raise Exception.new("#{stage} in #{k} is unknown")
          end
        end
      end
    end
  end

  # TODO:
  # copy keys and values from map to reduce block
  # copy keys from  map to finalize block
  # reduce_new.keys       = mrf.map.keys
  # reduce_new.values     = mrf.map.values
  # finalize_new.keys     = mrf.map.keys

  mrm.map_reduce_finalize = mrf
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

