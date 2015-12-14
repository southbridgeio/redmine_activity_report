class ActivityReportMailer < ActionMailer::Base
  layout 'mailer'
  helper :application
  helper :issues

  include Redmine::I18n

  default from: "#{Setting.app_title} <#{Setting.mail_from}>"

  def self.default_url_options
    Mailer.default_url_options
  end

  def report(period, user, interval, project_ids, activity_user_ids)
    I18n.locale = Setting['default_language']

    @user = user
    @interval = interval
    @time_entries = TimeEntry.where(project_id: project_ids, user_id: activity_user_ids, spent_on: interval).includes(:user, :issue)

    @total_hours = @time_entries.map(&:hours).sum
    @total_issues_count = @time_entries.map(&:issue_id).uniq.size

    @subject = if period == 'daily'
                t('activity_report.mailer.daily.subject', date: format_date(@interval))
              elsif period == 'weekly'
                t('activity_report.mailer.weekly.subject', from: format_date(@interval.first), to: format_date(@interval.last))
              elsif period == 'monthly'
                t('activity_report.mailer.monthly.subject', from: format_date(@interval.first), to: format_date(@interval.last))
              end

    mail to: @user.mail, subject: @subject
  end

end
