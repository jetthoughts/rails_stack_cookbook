#include_recipe 'unicorn'

node['rails-stack'][:applications].each_with_index do |application, i|

  app_path     = "#{node['rails-stack']['apps_path']}/#{application['name']}/current"
  shared_path  = "#{node['rails-stack']['apps_path']}/#{application['name']}/shared"
  app_log_path = "#{shared_path}/log"
  app_tmp_path = "#{shared_path}/tmp"

  # Web server Unicorn
  unicorn_monit_config application['name'] do
    rails_env application['rails_env']
    app_path  app_path
    tmp_path  app_tmp_path
    worker_name "#{application[:name]}_app"
  end

end
