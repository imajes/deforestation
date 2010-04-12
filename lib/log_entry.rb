require 'mongoid'

class LogEntry
  include Mongoid::Document
  
  field :sender
  field :destination
  field :sent_at, :type => DateTime
  field :message
  
end