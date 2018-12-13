class AddActivityReportSettingsToProjects < Rails.version < '5.0' ? ActiveRecord::Migration : ActiveRecord::Migration[4.2]
  def up
    add_column :projects, :activity_report_settings, :text
  end

  def down
    remove_column :projects, :activity_report_settings
  end
end
