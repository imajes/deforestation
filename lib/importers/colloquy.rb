require File.join(File.dirname(__FILE__), "/../parser.rb")

module Deforestation
  class Colloquy < Parser
    # inherit the methods on the main parser class
    
    attr_accessor :last_sender
    
    def initialize(file)
      @fh = Pathname.new(file)
      raise "Bad file given" if @fh.size == 0 || @fh.directory?
      super
    end
    
    def process!
      @ndoc = File.open(@fh.realpath) { |f| Nokogiri::XML(f) }

      @source = @ndoc.xpath('//log').first["source"].to_s

      @ndoc.xpath('//envelope').each do |r|
        r.children.each do |child|
          next if child.blank? # skip blank nodes

          if 'sender' == child.name
            @sender   = child.text
            @hostmask = child['hostmask']

            ## need to supply this, if it's self then this is what happens, otherwise the last sender?
            @destination = consider_sender(child['self'])
          else ## do msgs
            next unless child['id']

            @original_id = child["id"]
            @received_at = Time.parse(child["received"]).to_i ## turn it into an int...
            @message = child.text.strip
            send_to_mongo!
          end
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