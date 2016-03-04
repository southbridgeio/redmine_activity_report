every :day, at: '6:03' do
  rake 'activity_report:daily'
end

every :monday, at: '6:07' do
  rake 'activity_report:weekly'
end

every :month, at: '6:11' do
  rake 'activity_report:monthly'
end
