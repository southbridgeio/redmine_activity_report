namespace :activity_report do
  task daily: :environment do
    ActivityReport.send_activity_reports('daily')
  end
  task weekly: :environment do
    ActivityReport.send_activity_reports('weekly')
  end
  task monthly: :environment do
    ActivityReport.send_activity_reports('monthly')
  end
end
