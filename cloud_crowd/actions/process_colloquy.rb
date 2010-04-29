class ProcessColloquy < CloudCrowd::Action
  
  # This runs first and gets us the list of logs we're going to process
  # in this run
  def split
    log_path = ENV['LOG_PATH'] || '/Users/james/Documents/Colloquy Transcripts' ## fixme, generalize
    d = Dir.new(log_path)
    
    bad_names = ['.', '..']

    d.reject!{|file| bad_names.include?(file) }
    d.to_json
  end
  
  # this then runs on each, doing fun things for thems
  # 
  def process
    parser = Deforestation::Colloquy.new(input_path)
    parser.process!
  end
  
end