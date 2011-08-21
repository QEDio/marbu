require 'sinatra/base'
require 'haml'
require 'time'
require 'marbu'

module Marbu
  class Server < Sinatra::Base
    dir = File.dirname(File.expand_path(__FILE__))
    set :views, "#{dir}/server/views"
    set :public, "#{dir}/server/public"
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

    # to make things easier on ourselves
    get "/builder" do
      mrm_hsh     = Marbu.collection.find_one# || TMP_MR_WWB_LOC_DIM0
      @mrm        = Marbu::MapReduceModel.new(mrm_hsh)
      @builder    = Marbu::Builder.new(@mrm)
      
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    post "/builder" do
      puts "params: #{params.inspect}"
      @mrm         = Marbu::MapReduceModel.new
      map          = Marbu::MapReduceModel::MapModel.new
      reduce       = Marbu::MapReduceModel::ReduceModel.new
      finalize     = Marbu::MapReduceModel::FinalizeModel.new

      @mrm.map      = map
      @mrm.reduce   = reduce
      @mrm.finalize = finalize

      map.code         = params.delete('map_code')
      reduce.code      = params.delete('reduce_code')
      finalize.code    = params.delete('finalize_code')

      sorted_params = sort_params(params)

      # rebuild mapreduce model
      sorted_params.each do |k,v|
        k =~ /(.+?)_(.+?)_(.*)/

        case $1
          when 'map'        then add(map, $2, v[:name], v[:function])
          when 'reduce'     then add(reduce, $2, v[:name], v[:function])
          when 'finalize'   then add(finalize, $2, v[:name], v[:function])
          else raise Exception.new("#{$1} in #{k} is unknown")
        end
      end

      Marbu.collection.insert(@mrm.hash)

      @builder    = Marbu::Builder.new(@mrm)
      @map        = {:blocks => @mrm.map, :code => @builder.map, :type => "map"}
      @reduce     = {:blocks => @mrm.reduce, :code => @builder.reduce, :type => "reduce"}
      @finalize   = {:blocks => @mrm.finalize, :code => @builder.finalize, :type => "finalize"}

      show 'builder'
    end

    #### fuuu, rebuild mapreduce model from provided params hash
    # wouldn't be necessary if I know HTML
    def sort_params(params)
      {}.tap do |sorted_params|
        params.each_pair do |k,v|
          # map parameters
          k =~ /(.+?)_(.+?)_(.+?)_(.*)/

          next if $1.nil?

          block       = $1
          type        = $2
          sub_type1    = $3
          number      = $4

          next if sorted_params.key?("#{block}_#{type}_#{number}")

          sub_type2 = sub_type1.eql?("name") ? "function" : "name"
          v2 = params["#{block}_#{type}_#{sub_type2}_#{number}"]
          raise Exception.new("corresponding param not found") if v2.nil?

          sorted_params["#{block}_#{type}_#{number}"] = {:name => v, :function => v2}
        end
      end
    end

    def add(model, type, name, function)
      case type
        when 'key'      then model.add_key(name, function)
        when 'value'    then model.add_value(name, function)
        else raise Exception.new("#{type} is unknown")
      end
    end

    #%w( builder ).each do |page|
    #  get "/#{page}" do
    #    show page
    #  end
    #
    #  get "/#{page}/:id" do
    #    show page
    #  end
    #end

    def show(page)
      haml page.to_sym
    end
  end

end
