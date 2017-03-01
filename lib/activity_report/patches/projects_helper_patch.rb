# This file is a part of Redmine CRM (redmine_contacts) plugin,
# customer relationship management plugin for Redmine
#
# Copyright (C) 2011-2015 Kirill Bezrukov
# http://www.redminecrm.com/
#
# redmine_contacts is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# redmine_contacts is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with redmine_contacts.  If not, see <http://www.gnu.org/licenses/>.

require_dependency 'queries_helper'

module ActivityReport
  module Patches
    module ProjectsHelperPatch
      def self.included(base)
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          alias_method_chain :project_settings_tabs, :activity_report_settings
        end
      end

      module InstanceMethods
        def project_settings_tabs_with_activity_report_settings
          tabs = project_settings_tabs_without_activity_report_settings

          if User.current.allowed_to?(:manage_activity_report_settings, @project)
            tabs.push(name: 'activity_report_settings',
                      action: :manage_activity_report_settings,
                      partial: 'projects/settings/activity_report',
                      label: 'activity_report.tab_title')
          end

          tabs
        end
      end
    end
  end
end

unless ProjectsHelper.included_modules.include?(ActivityReport::Patches::ProjectsHelperPatch)
  ProjectsHelper.send(:include, ActivityReport::Patches::ProjectsHelperPatch)
end
