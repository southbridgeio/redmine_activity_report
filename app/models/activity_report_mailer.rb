class ActivityReportMailer < ActionMailer::Base
  layout 'mailer'
  helper :application
  helper :issues

  include Redmine::I18n

  default from: Setting.mail_from

  def self.default_url_options
    Mailer.default_url_options
  end

  def report(period, user_id, interval, params)
    data_prepare(interval, params, period, user_id)

    if @data.present?
      @subject = case period
        when 'daily' ; t('activity_report.mailer.daily.subject', date: format_date(@interval))
        when 'weekly' ; t('activity_report.mailer.weekly.subject', number: interval.first.strftime('%W'))
        when 'monthly' ; t('activity_report.mailer.monthly.subject', from: format_date(@interval.first), to: format_date(@interval.last))
      end

      @title = case period
        when 'weekly' ; t('activity_report.mailer.weekly.title', from: format_date(@interval.first), to: format_date(@interval.last))
      end

      mail to: @user.mail, subject: @subject
    end
  end

  def tracker_report(period, user_id, interval, params, tracker_id)
    data_prepare(interval, params, period, user_id, tracker_id)

    if @data.present?
      @tracker = Tracker.find(tracker_id)

      @subject = case period
        when 'daily' ; t('activity_report.mailer.tracker.daily.subject', date: format_date(@interval), tracker_name: @tracker.name)
        when 'weekly' ; t('activity_report.mailer.tracker.weekly.subject', from: format_date(@interval.first), to: format_date(@interval.last), tracker_name: @tracker.name)
        when 'monthly' ; t('activity_report.mailer.tracker.monthly.subject', from: format_date(@interval.first), to: format_date(@interval.last), tracker_name: @tracker.name)
      end

      @title = case period
        when 'daily' ; t('activity_report.mailer.tracker.daily.title', date: format_date(@interval), tracker_name: @tracker.name)
        when 'weekly' ; t('activity_report.mailer.tracker.weekly.title', from: format_date(@interval.first), to: format_date(@interval.last), tracker_name: @tracker.name)
        when 'monthly' ; t('activity_report.mailer.tracker.monthly.title', from: format_date(@interval.first), to: format_date(@interval.last), tracker_name: @tracker.name)
      end

      mail to: @user.mail, subject: @subject.gsub(t('activity_report.mailer.tracker.gsub'), ''), template_name: 'report'
    end
  end

  def data_prepare(interval, params, period, user_id, tracker_id = nil)
    I18n.locale = Setting['default_language']

    @period   = period
    @user     = User.find user_id
    @interval = interval

    @data = params.map do |project_id, options|
      project           = Project.find project_id
      project_ids       = options[:project_ids]
      activity_user_ids = options[:activity_user_ids]
      time_entries      = if tracker_id.present?
                            TimeEntry.includes(:user, :issue)
                                     .where(project_id: project_ids, user_id: activity_user_ids, spent_on: interval,
                                            issues:     { tracker_id: tracker_id })
                          else
                            TimeEntry.includes(:user, :issue)
                                     .where(project_id: project_ids, user_id: activity_user_ids, spent_on: interval)
                          end

      created_on_interval = if interval.is_a?(Array)
                              interval.first.beginning_of_day..interval.last.end_of_day
                            else
                              interval
                            end

      alarm_issues = Issue.where(project_id:  project_ids,
                                 created_on: created_on_interval,
                                 priority_id: Setting.plugin_redmine_activity_report['alarm_priority_ids']).includes(:journals)

      alarm_issues = alarm_issues.where(tracker_id: tracker_id) if tracker_id.present?

      time_for_reaction = Setting.plugin_redmine_activity_report['time_for_reaction'].to_i

      overdue_alarm_issues = alarm_issues.map do |issue|
        created_on               = issue.created_on
        first_activity           = issue.journals.where(user_id: activity_user_ids).first
        reaction_time_in_seconds = first_activity.present? ? (first_activity.created_on - created_on) : (Time.now - created_on)
        [issue, (reaction_time_in_seconds / 60).round]
      end.select { |_, rt| rt > time_for_reaction }.sort_by { |_, rt| -rt }

      total_hours        = time_entries.map(&:hours).sum
      total_issues_count = time_entries.map(&:issue_id).uniq.size
      {
        project:              project,
        overdue_alarm_issues: overdue_alarm_issues,
        time_entries:         time_entries,
        total_hours:          total_hours,
        total_issues_count:   total_issues_count
      }
    end.select { |d| d[:time_entries].present? || d[:overdue_alarm_issues].present? }.sort_by { |d| d[:project].name }
  end
end
