require 'lib/parser'
require 'lib/importers/colloquy'

namespace :deforestation do
  
  desc "Run the colloquy parsers, set LOG_PATH in env to instruct location"
  task :colloquy do
    log_path = ENV['LOG_PATH'] || '/Users/james/Documents/Colloquy Transcripts' ## fixme, generalize
    d = Dir.new(log_path)

    puts "now processing for #{log_path}"
    
    d.each do |f|
      next if f == "." || f == ".."
      puts "processing #{f}..."
      Deforestation::Colloquy.new("#{log_path}/#{f}")
    end
  end
end
