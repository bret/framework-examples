require 'spec/rake/spectask'

Spec::Rake::SpecTask.new do |task|
  task.spec_files = '*.rb'
  task.spec_opts << '--color --format specdoc'
end

task :default => :spec