[![Rate at redmine.org](http://img.shields.io/badge/rate%20at-redmine.org-blue.svg?style=flat)](http://www.redmine.org/plugins/redmine_activity_report)
# Redmine activity report plugin

*[English version](README.md)*

Плагин предназначен для отправки ежедневных, еженедельных и ежемесячных отчётов о затраченном времени по проектам.

Пожалуйста помогите нам сделать этот плагин лучше, сообщая во вкладке [Issues](https://github.com/southbridgeio/redmine_activity_report/issues) обо всех проблемах, с которыми Вы столкнётесь при его использовании. Мы готовы ответить на все ваши вопросы, касающиеся этого плагина.

## Установка и настройка плагина

После установки плагина необходимо установить зависимости

```
bundle install
```

и запустить скрипт миграции для базы данных:

```
bundle exec rake redmine:plugins:migrate
```

## Задание cron

Для добавления регулярных задач в cron:

```
bundle exec whenever -i redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

Для удаления из cron:

```
bundle exec whenever -c redmine_activity_report -f plugins/redmine_activity_report/config/schedule.rb
```

## Использование плагина

Имейте ввиду, плагин учитывает только время, проставленное в тикетах.

Отметьте в разделе `Приоритеты срочных задач` приоритеты для включения их в отчёт. Отметьте трекеры в разделе `Отправлять отдельный отчёт по трекерам` если Вы хотите добавить их в отчёт.

во вкладке `Activity report` отметьте `Включая подпроекты` чтобы включить подпроекты главного проекта в отчёт. В разделе `Исполнители для отчёта` указываются пользователи, которые будут добавлены в отчёт. В разделе `Получатели отчёта` указываются пользователи, которые будут получать отчёты.

# Автор плагина

Плагин разработан [Southbridge](https://southbridge.io)
