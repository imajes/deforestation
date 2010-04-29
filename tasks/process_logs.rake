require 'lib/parser'
require 'lib/importers/colloquy'

namespace :deforestation do
  
  desc "Run the colloquy parsers, set LOG_PATH in env to instruct location"
  task :colloquy do
    log_path = ENV['LOG_PATH'] || '/Users/james/Documents/Colloquy Transcripts' ## fixme, generalize
    d = Dir.new(log_path)

    puts "now processing for #{log_path}"
    
    idx = 0
    MAX_FORKS = 10
    
    d.each do |f|
      next if f == "." || f == ".."
      break if idx > 3
      puts "processing #{f}..."
      @file = f
      Kernel.fork {
        lp = Deforestation::Colloquy.new("#{log_path}/#{@file}")
        lp.process!
      }
      idx += 1
    end
  end
end
