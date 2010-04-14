require 'bundler'
Bundler.setup(:importer)
Bundler.require(:importer)

# 
# d = Nokogiri::XML(open("mattly (irc.freenode.net).colloquyTranscript"))
# 
# d.xpath('//envelope').each do |r|
#   sender = r.xpath('//sender')
# end

module Deforestation
  class Parser
    include ::HTTParty
    base_uri 'localhost:9393'
    
    attr_accessor :data
  
    def initialize
      @data = {:sender => "imajes", :destination => "jacqui", :original_received_at => Time.now, :message => "testing", :hostmask => "james@imaj.es", :source => "testing", :original_message_id => "12312312" }
    end
    
    def send_to_mongo!
      rv = self.class.post('/entries/new', :body => @data)
      puts rv.inspect
    end
    
  end
end


r = Deforestation::Parser.new
r.send_to_mongo!