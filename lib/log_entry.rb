require 'mongoid'

class LogEntry
  include Mongoid::Document
  include Mongoid::Timestamps
  
  field :sender
  field :destination
  field :sent_at, :type => DateTime
  field :message
  field :network
  
end