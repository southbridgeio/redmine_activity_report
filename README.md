[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=flat)](http://www.redmine.org/plugins/redmine_activity_report)
# Redmine activity report plugin

*[Русская версия документации](README.ru.md)*

The plugin is designed to send reports of the time spent on projects daily, weekly and monthly.

Please help us make this plugin better telling us of any [issues](https://github.com/southbridgeio/redmine_activity_report/issues) you'll face using it. We are ready to answer all your questions regarding this plugin.

## Plugin setup

Install the plugin into `plugins/redmine_activity_report`, install the dependencies

```
bundle install
```

and perform database migration:

```
bundle exec rake redmine:plugins:migrate
```

## Adding/removing cronjob

Add regular task to cron:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Remove regular task from cron:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```
## Usage

Keep in mind that the plugin only counts the time put in tickets.

Tick the priority statuses in the `Alarm priorities` section to include them in report.
Tick trackers in the `Send a separate report on trackers` section if you'd like them to be added to the report.

Tick `With sub-projects` on the `Activity report` tab to receive reports of all the subprojects included in the project.
`Users for activity report` section contains users that will be included in report.
`Report receivers` section contains users that will receive reports.

# Author of the Plugin

The plugin is designed by [Southbridge](https://southbridge.io)
