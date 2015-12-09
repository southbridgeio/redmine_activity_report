every :day, at: '00:01' do
  rake 'activity_report:daily'
end

every :monday, at: '00:01' do
  rake 'activity_report:weekly'
end

every :month, at: '00:01' do
  rake 'activity_report:monthly'
end
