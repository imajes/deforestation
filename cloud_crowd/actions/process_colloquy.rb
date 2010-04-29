require '../lib/importers/colloquy.rb'

class ProcessColloquy < CloudCrowd::Action

  # this then runs on each, doing fun things for thems
  # 
  def process
    file_to_parse = options["log_path"] + "/" + input
    
    parser = Deforestation::Colloquy.new(file_to_parse)
    parser.process!
  end
  
end