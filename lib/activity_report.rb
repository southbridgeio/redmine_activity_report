module ActivityReport
  def self.send_activity_reports(period)
    yesterday = 12.hours.ago.to_date
    interval = if period == 'daily'
                 yesterday
               elsif period == 'weekly'
                 (yesterday.beginning_of_week..yesterday.end_of_week).to_a
               elsif period == 'monthly'
                 (yesterday.beginning_of_month..yesterday.end_of_month).to_a
               end

    report_data = {

    }

    projects = Project.active.select do |project|
      project.module_enabled?(:activity_report)
    end

    projects.each do |project|
      activity_group_ids = project.activity_group_ids
      activity_user_ids = project.activity_user_ids

      group_users = project.groups.where(id: activity_group_ids).map(&:users).flatten
      users = project.users.where(id: activity_user_ids)

      all_activity_user_ids = (group_users + users).uniq.map(&:id)

      report_user_ids = project.report_user_ids
      report_users = project.users.where(id: report_user_ids)

      project_ids = if project.with_subprojects.present?
                      Project.where(project.project_condition(true)).pluck(:id)
                    else
                      [project.id]
                    end

      report_users.each do |user|
        report_data[user.id] = {} unless report_data[user.id].present?

        report_data[user.id][project.id] = {
          project_ids: project_ids,
          activity_user_ids: all_activity_user_ids
        }
      end
    end

    report_data.each do |user_id, params|
      ActivityReportMailer.report(period, user_id, interval, params).deliver_now
      if Setting.plugin_redmine_activity_report['separate_tracker_ids'].present? &&
         Setting.plugin_redmine_activity_report['separate_tracker_ids'].is_a?(Array)

        Setting.plugin_redmine_activity_report['separate_tracker_ids'].each do |tracker_id|
          ActivityReportMailer.tracker_report(period, user_id, interval, params, tracker_id).deliver_now
        end
      end
    end
  end
end
