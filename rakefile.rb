require 'rspec/core/rake_task'

desc "Run the specs."
task :test => [:import_test_data] do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/*_spec.rb'
  end
  Rake::Task["spec"].execute
end

desc "Restore mongo with venue test data"
task :import_test_data do
  sh("./scripts/restore-venue-db")
end
