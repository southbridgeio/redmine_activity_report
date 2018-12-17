require_dependency 'project'

module ActivityReport
  module Patches
    module ProjectPatch
      def self.included(base) # :nodoc:
        base.send(:include, InstanceMethods)

        base.class_eval do
          unloadable

          accessors = %w(with_subprojects activity_group_ids activity_user_ids report_user_ids)
          store :activity_report_settings,
                accessors: accessors

          accessors.each do |accessor|
            define_method(:accessor) do
              super() || []
            end
          end
        end
      end

      module InstanceMethods
        def groups
          @groups ||= Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", id).uniq
        end
      end
    end
  end
end

Project.send(:include, ActivityReport::Patches::ProjectPatch)
