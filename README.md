# Redmine activity report plugin

*[Русская версия документации](README.ru.md)*

Plugin developed by [Centos-admin.ru](http://centos-admin.ru/)..

The plugin is designed to send daily, weekly and monthly reports on the elapsed time on the project.

## Plugin Setup

Install the plugin and perform database migration:

```
bundle exec rake redmine:plugins:migrate
```

## CRON

Add regular tasks to CRON:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Perform this to remove tasks from CRON:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

