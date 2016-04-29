# Redmine activity report plugin

*[Русская версия документации](README.ru.md)*

Plugin developed by [Centos-admin.ru](http://centos-admin.ru/).

The plugin is designed to send daily, weekly and monthly reports on the elapsed time on the project.

Please help us make this plugin better telling us of any [issues](https://github.com/centosadmin/redmine_activity_report/issues) you'll face using it. We are ready to answer all your questions regarding this plugin.

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

