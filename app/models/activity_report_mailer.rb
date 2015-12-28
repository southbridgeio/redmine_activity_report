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

      total_hours = time_entries.map(&:hours).sum
      total_issues_count = time_entries.map(&:issue_id).uniq.size
      {
        project: project,
        time_entries: time_entries,
        total_hours: total_hours,
        total_issues_count: total_issues_count
      }
    end.select { |d| d[:time_entries].present? }.sort_by { |d| d[:project].name }


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
