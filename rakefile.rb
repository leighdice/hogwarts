desc "Run the specs."
task :test => [:import_test_data] do
  system('bundle exec rspec')
end

desc "Restore mongo with venue test data"
task :import_test_data do
  sh("./scripts/restore-venue-db")
end
