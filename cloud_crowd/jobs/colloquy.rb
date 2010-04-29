#!/usr/bin/env ruby -rubygems

require 'restclient'
require 'json'

@log_path = ENV['LOG_PATH'] || '/Users/james/Documents/Colloquy Transcripts' ## fixme, generalize
@dir = Dir.new(@log_path).to_a

bad_names = ['.', '..']

@dir.reject!{|file| bad_names.include?(file) }

RestClient.post('http://localhost:9173/jobs', 
  {:job => {
  
    'action' => 'process_colloquy',
    'options' => {
      'log_path' => @log_path
    },
    'inputs' => @dir
    
  }.to_json}
)
