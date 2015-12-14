every :day do
  rake 'activity_report:daily'
end

every :monday do
  rake 'activity_report:weekly'
end

every :month do
  rake 'activity_report:monthly'
end
