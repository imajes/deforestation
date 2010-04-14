require 'bundler'
Bundler.setup(:importer)
Bundler.require(:importer)

module Deforestation
  class Colloquy < Parser
    # inherit the methods on the main parser class
    
    attr_accessor :last_sender
    
    def initialize(file)
      @fh = Pathname.new(file)
      raise "Bad file given" if @fh.size == 0 || @fh.directory?
      process!
    end
    
    def process!
      @ndoc = Nokogiri::XML(@fh.read)

      @source = @ndoc.xpath('//log').first.attributes["source"].to_s

      @ndoc.xpath('//envelope').each do |r|
        @sender = r.xpath('//sender').first.inner_text
        
        @hostmask = r.xpath('//sender').first.attributes['hostmask'].to_s

        ## need to supply this, if it's self then this is what happens, otherwise the last sender?
        @destination = consider_sender(r.xpath('//sender').first.attributes['self'])

        ## iterate for message
        r.children.each do |c|
          next unless c.attributes && c.attributes["id"]
          @original_message_id = c.attributes["id"].to_s
          @received_at = c.attributes["received"].to_s
          @message = c.inner_text
          send_to_mongo!
        end
      end
    end
    
    def consider_sender(self_as_sender)
      if source =~ /%23/
        ## channel, so that's the destination
        @destination = source.split("/").reverse.first.gsub("%23", "#") ## tidy name for channel
      elsif self_as_sender
        # we're in a user chat, so send the cached destination
        @destination = @last_sender
      else
        # i must be the target, but cache the sender
        @last_sender = sender ## cache who we're talking to
        @destination = 'imajes'
      end
    end
    
    
  end
end