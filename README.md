# Redmine activity report plugin

Плагин разработан [Centos-admin.ru](http://centos-admin.ru/).

Плагин предназначен для отправки ежедневных, еженедельных и ежемесячных отчётов о затраченном времени по проектам.

## Установка и настройка плагина

После установки плагина необходимо запустить миграции для базы данных:

```
bundle exec rake redmine:plugins:migrate
```

## CRON

Для добавления ежедневной задачи в CRON:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Для очистки CRON:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

