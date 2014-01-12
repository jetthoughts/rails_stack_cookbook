include_recipe 'rails-stack::update_packages'

# User deployer
include_recipe 'rails-stack::user'
include_recipe 'rails-stack::lib_directory'

# Rbenv
include_recipe 'rbenv'
include_recipe 'rbenv::ruby_build'
include_recipe 'rbenv::rbenv_vars'

directory "#{node['rails-stack']['data_path']}/tmp" do
  recursive true
  mode '0777'
end

ENV['TMPDIR'] = "#{node['rails-stack']['data_path']}/tmp"
rbenv_ruby node[:ruby][:version]

rbenv_gem 'bundler' do
  ruby_version node[:ruby][:version]
end

include_recipe 'rails-stack::rbenv_wrapper'

# Monit
include_recipe 'monit'

if node['platform_family'] == 'rhel'
  template '/etc/monit.conf' do
    cookbook 'monit'
    owner 'root'
    group 'root'
    mode 0700
    source 'monitrc.erb'
    notifies :restart, resources(service: 'monit'), :delayed
  end
end

# Nginx
include_recipe 'nginx'

# Postfix - local smtp server
include_recipe 'postfix'

# Imagemagick tools
include_recipe 'imagemagick'
include_recipe 'imagemagick::devel'

# Memcached service
include_recipe 'memcached'

# Logrotate
include_recipe 'logrotate::default'

# Postgresql
include_recipe 'rails-stack::pgdg'

# Nodejs
include_recipe 'nodejs'

# Rails applications
include_recipe 'rails-stack::applications'

# Monit configurations for services
include_recipe 'rails-stack::monit'
