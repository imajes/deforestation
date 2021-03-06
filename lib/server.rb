require 'rubygems'
require 'sinatra'
require 'sinatra/mongoid'
require "mongoid"
require "bson"
require 'erb'

## models
require File.dirname(File.expand_path(__FILE__)) + '/log_entry'

## much here stolen from the excellent resque!
module Deforestation
  class Server < ::Sinatra::Base
      dir = File.dirname(File.expand_path(__FILE__))

      set :views,  "#{dir}/server/views"
      set :public, "#{dir}/server/public"
      set :static, true

      set :mongo_db, 'deforestation'

      helpers do
        include Rack::Utils
        alias_method :h, :escape_html

        def current_section
          url request.path_info.sub('/','').split('/')[0].downcase
        end

        def current_page
          url request.path_info.sub('/','')
        end

        def url(*path_parts)
          [ path_prefix, path_parts ].join("/").squeeze('/')
        end
        alias_method :u, :url

        def path_prefix
          request.env['SCRIPT_NAME']
        end

        def class_if_current(path = '')
          'class="current"' if current_page[0, path.size] == path
        end
      end
     
      def show(page, layout = true, data = nil)
        data = {} if data.nil?
        begin
          erb page.to_sym, {:layout => layout}, :locals => data
        rescue Errno::ECONNREFUSED
          erb :error, {:layout => false}, :error => "oh goshes"
        end
      end
      
      
      ## now to the meat of the app
      
      
      get "/entries/:source" do
        source = params[:source]
        @entries = Deforestation::LogEntry.where(:source => /(.*)#{source}/i).order_by([:received_at, :desc]).limit(100)
        puts Time.now
        show :entries, true, @entries
      end
      
      get "/user/:source" do
        @entries = Deforestation::LogEntry.where(:sender => params[:source]).order_by([:received_at, :desc])
        show :user, true, {:entries => @entries, :source => params[:source]}
      end
      
  end
end