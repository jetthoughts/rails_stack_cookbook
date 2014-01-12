include_recipe 'delayed_job'
include_recipe 'unicorn'

dj_monit_config node['rails-stack'][:applications]

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

  # Nginx site
  template "#{node['nginx']['dir']}/sites-available/#{application['name']}" do
    source 'nginx/default.conf.erb'
    notifies :reload, 'service[nginx]'
    variables name: application['name'],
              app_path: app_path,
              log_path: app_log_path,
              tmp_path: app_tmp_path,
              ssl_redirect: application['ssl_redirect']
  end

  nginx_site application['name']

  if application['ssl']
    # Nginx SSL site
    template "#{node['nginx']['dir']}/sites-available/#{application['name']}_ssl" do
      source 'nginx/default.ssl.conf.erb'
      notifies :reload, 'service[nginx]'
      variables name: application['name'],
                app_path: app_path,
                log_path: app_log_path,
                tmp_path: app_tmp_path,
                certs_dir: node['ssl']['certs_dir'],
                keys_dir: node['ssl']['keys_dir'],
                domain: application['domain'].gsub(/[^a-zA-Z.]/, '.')
    end

    nginx_site "#{application['name']}_ssl"
  end

  # Logrotate for application
  logrotate_app application['name'] do
    cookbook  'logrotate'
    path      File.join(app_log_path, '*.log')
    frequency 'daily'
    rotate    30
    create    "644 #{node['rails-stack']['deployer']} #{node['rails-stack']['deployer']}"
  end
end
