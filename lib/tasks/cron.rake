# heroku hourly cron task.
desc 'Import new tweets every hour'
task :cron => :environment do
  TwitterImporter.import!
end