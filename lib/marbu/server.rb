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

      @mrm = Marbu::MapReduceModel.new(TMP_MR_WWB_LOC_DIM0)
      @map = @mrm.map

      show 'builder'
    end

    post "/builder" do
      
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
