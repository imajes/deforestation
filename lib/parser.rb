require 'nokogiri'

d = Nokogiri::XML(open("mattly (irc.freenode.net).colloquyTranscript"))

d.xpath('//envelope').each do |r|
  sender = r.xpath('//sender')