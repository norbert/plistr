require 'rake'
require 'rake/testtask'

task :default => :spec

Rake::TestTask.new(:spec) do |t|
  ENV['TESTOPTS'] = '--runner=s'

  t.libs << 'lib'
  t.pattern = 'spec/**/*_spec.rb'
  t.verbose = true
end
