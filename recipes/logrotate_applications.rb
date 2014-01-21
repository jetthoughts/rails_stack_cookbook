node['rails-stack'][:applications].each_with_index do |application, i|

  app_path     = "#{node['rails-stack']['apps_path']}/#{application['name']}/current"
  shared_path  = "#{node['rails-stack']['apps_path']}/#{application['name']}/shared"
  app_log_path = "#{shared_path}/log"
  app_tmp_path = "#{shared_path}/tmp"

  # Logrotate for application
  logrotate_app application['name'] do
    cookbook  'logrotate'
    path      File.join(app_log_path, '*.log')
    frequency 'daily'
    rotate    30
    create    "644 #{node['rails-stack']['deployer']} #{node['rails-stack']['deployer']}"
  end
end
