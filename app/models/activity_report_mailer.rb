class ActivityReportMailer < ActionMailer::Base
  layout 'mailer'
  helper :application
  helper :issues

  include Redmine::I18n

  default from: "#{Setting.app_title} <#{Setting.mail_from}>"

  def self.default_url_options
    Mailer.default_url_options
  end

  def report(period, user_id, interval, params)
    I18n.locale = Setting['default_language']

    @period = period
    @user = User.find user_id
    @interval = interval

    @data = params.map do |project_id, options|
      project = Project.find project_id
      project_ids = options[:project_ids]
      activity_user_ids = options[:activity_user_ids]
      time_entries = TimeEntry.where(project_id: project_ids, user_id: activity_user_ids, spent_on: interval).includes(:user, :issue)

      alarm_issues = Issue.where(project_id: project_ids, created_on: interval,
                                 priority_id: Setting.plugin_redmine_activity_report['alarm_priority_ids']).includes(:journals)

      time_for_reaction = Setting.plugin_redmine_activity_report['time_for_reaction'].to_i

      overdue_alarm_issues = alarm_issues.map do |issue|
        created_on = issue.created_on
        first_activity = issue.journals.where(user_id: activity_user_ids).first
        reaction_time_in_seconds = first_activity.present? ? (first_activity.created_on - created_on) : (Time.now - created_on)
        [issue, (reaction_time_in_seconds / 60)]
      end.select{|i, rt| rt > time_for_reaction}.sort_by{|i, rt| -rt}

      total_hours = time_entries.map(&:hours).sum
      total_issues_count = time_entries.map(&:issue_id).uniq.size
      {
        project: project,
        overdue_alarm_issues: overdue_alarm_issues,
        time_entries: time_entries,
        total_hours: total_hours,
        total_issues_count: total_issues_count
      }
    end.select { |d| d[:time_entries].present? or d[:overdue_alarm_issues].present? }.sort_by { |d| d[:project].name }


    @subject = if period == 'daily'
                 t('activity_report.mailer.daily.subject', date: format_date(@interval))
               elsif period == 'weekly'
                 t('activity_report.mailer.weekly.subject', from: format_date(@interval.first), to: format_date(@interval.last))
               elsif period == 'monthly'
                 t('activity_report.mailer.monthly.subject', from: format_date(@interval.first), to: format_date(@interval.last))
               end

    if @data.present?
      mail to: @user.mail, subject: @subject
    end
  end

end
