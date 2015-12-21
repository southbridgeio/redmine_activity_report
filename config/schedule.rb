every :day, at: '0:03' do
  rake 'activity_report:daily'
end

every :monday, at: '0:07' do
  rake 'activity_report:weekly'
end

every :month, at: '0:11' do
  rake 'activity_report:monthly'
end
