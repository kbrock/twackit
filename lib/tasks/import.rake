namespace :twackit do

  desc 'Import new tweets'
  task :import => :environment do
    TwitterImporter.import!
  end
  
end
