require 'mongoid'

module Deforestation
  class LogEntry
    include Mongoid::Document
    include Mongoid::Timestamps

    field :sender
    field :hostmask
    field :destination
    field :received_at
    field :message
    field :source
    field :original_id # originator id, where present
  end  
end