require 'bundler'
Bundler.setup(:importer)
Bundler.require(:importer)
require 'pathname'

module Deforestation
  class Parser
    include ::HTTParty
    
    base_uri '127.0.0.1:9393'
    
    attr_accessor :source, :sender, :hostmask, :destination, :original_id, :received_at, :message
  
    def initialize(data)
      @data = {}.merge(data)
    end
    
    def send_to_mongo!
      begin
        self.class.post('/entries/new', :body => prepare_data)
      rescue ResponseError
        raise "You need to run the server first!"
      end
    end
    
    protected
    def prepare_data
      {:source => source, :sender => sender, :hostmask => hostmask, :destination => destination, 
       :original_id => original_id, :message => message, :received_at => received_at}
    end
    
  end
end
