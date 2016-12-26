# start everyday on 6:03 am to generate daily report
every :day, at: '6:03' do
  rake 'activity_report:daily'
end

# start Monday on 6:07 am to generate weekly report
every :monday, at: '6:07' do
  rake 'activity_report:weekly'
end

# start 1st day of month on 6:11 am to generate monthly report
every :month, at: '6:11' do
  rake 'activity_report:monthly'
end
