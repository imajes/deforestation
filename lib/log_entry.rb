require 'mongoid'

module Deforestation
  class LogEntry
    include Mongoid::Document
    include Mongoid::Timestamps

    key :sender, :original_received_at #composite key for uniq

    field :sender
    field :hostmask
    field :destination
    field :received_at, :default => nil
    field :original_received_at ## date time fail
    field :message
    field :source
    field :original_message_id # originator id, where present
  end  
end