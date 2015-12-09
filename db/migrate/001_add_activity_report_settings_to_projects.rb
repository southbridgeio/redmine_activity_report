class AddActivityReportSettingsToProjects < ActiveRecord::Migration
  def up
    add_column :projects, :activity_report_settings, :text
  end

  def down
    remove_column :projects, :activity_report_settings
  end
end
