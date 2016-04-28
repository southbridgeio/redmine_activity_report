# Redmine activity report plugin

*[English version](README.md)*

Плагин разработан [Centos-admin.ru](http://centos-admin.ru/).

Плагин предназначен для отправки ежедневных, еженедельных и ежемесячных отчётов о затраченном времени по проектам.

Пожалуйста помогите нам сделать этот плагин лучше, сообщая во вкладке [Issues](https://github.com/centosadmin/redmine_activity_report/issues) обо всех проблемах, с которыми Вы столкнётесь при его использовании. Мы готовы ответить на Все ваши вопросы, касающиеся этого плагина.

## Установка и настройка плагина

После установки плагина необходимо запустить миграции для базы данных:

```
bundle exec rake redmine:plugins:migrate
```

## CRON

Для добавления регулярных задач в CRON:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Для очистки CRON:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

