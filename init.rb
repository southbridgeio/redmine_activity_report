require 'redmine'
require_dependency  File.dirname(__FILE__) + '/lib/activity_report'
require_dependency  File.dirname(__FILE__) + '/lib/activity_report/patches/project_patch'
require_dependency  File.dirname(__FILE__) + '/lib/activity_report/patches/projects_helper_patch'

Redmine::Plugin.register :redmine_activity_report do
  name 'Redmine Activity Report plugin'
  url 'https://github.com/southbridgeio/redmine_activity_report'
  description 'This is a plugin for Redmine which generate time reports for projects'
  version '1.2.10'
  author 'Southbridge'
  author_url 'https://github.com/southbridgeio'

  settings(partial: 'activity_report/settings',
           default: { 'time_for_reaction' => 15,
                      'alarm_priority_ids' => [] })

  project_module :activity_report do
    permission :manage_activity_report_settings, projects: :settings,
                                                 activity_report_settings: :save
  end
end
