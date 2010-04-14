load 'tasks/process_logs.rake'
#require 'rake/testtask'

$LOAD_PATH.unshift 'lib'

def command?(command)
  system("type #{command} > /dev/null")
end

task :default => :test

desc "Run the test suite"
task :test do
  rg = command?(:rg)
  Dir['test/**/*_test.rb'].each do |f|
    rg ? sh("rg #{f}") : ruby(f)
  end
end

if command? :kicker
  desc "Launch Kicker (like autotest)"
  task :kicker do
    puts "Kicking... (ctrl+c to cancel)"
    exec "kicker -e rake test lib examples"
  end
end