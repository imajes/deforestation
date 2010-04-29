require 'bundler'
Bundler.setup(:importer)
Bundler.require(:importer)
require 'pathname'

module Deforestation
  class Parser
    include ::Mongo
    
    attr_accessor :source, :sender, :hostmask, :destination, :original_id, :received_at, :message
  
    def initialize(data)
      @data = {}.merge(data) if data.is_a?(Hash)
      db = Connection.new.db('deforestation')
      @collection = db.collection('logFiles')
    end
    
    def send_to_mongo!
      begin
        @collection.insert(prepare_data)
      rescue ## dupe keys
      end
    end
    
    protected
    def prepare_data
      {:source => source, :sender => sender, :hostmask => hostmask, :destination => destination, 
       :original_id => original_id, :message => message, :received_at => received_at}
    end
    
  end
end
