# Redmine activity report plugin

*[Русская версия документации](README.ru.md)*

Plugin developed by [Centos-admin.ru](http://centos-admin.ru/)..

The plugin is designed to send daily, weekly and monthly reports on the elapsed time on the project.

## Plugin Setup

After install plugin, run it database migrations:

```
bundle exec rake redmine:plugins:migrate
```

## CRON

Add regular tasks to CRON:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Clear CRON:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

