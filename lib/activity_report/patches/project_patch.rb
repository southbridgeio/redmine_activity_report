module ActivityReport
  module ProjectPatch
    def self.included(base) # :nodoc:
      base.class_eval do
        unloadable

        # noinspection RubyArgCount
        store :activity_report_settings,
              accessors: %w(with_subprojects activity_group_ids activity_user_ids report_user_ids)

        def groups
          @groups ||= Group.active.joins(:members).where("#{Member.table_name}.project_id = ?", id).uniq
        end

      end
    end

  end
end
Project.send(:include, ActivityReport::ProjectPatch)
