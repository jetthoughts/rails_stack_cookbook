general_packages = case node['platform_family']
                   when 'debian', 'ubuntu'
                     include_recipe 'apt'
                     %w(libreadline6 libreadline6-dev git autoconf libssl-dev zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 libxml2-dev libxslt-dev libpq-dev libffi-dev)
                   when 'rhel'
                     include_recipe 'yum-epel'
                     package 'yum-plugin-versionlock'

                     package 'openssl-devel'
                     #package 'openssl-devel' do
                     #  version '1.0.0-27.el6_4.2'
                     #end

                     #execute 'yum versionlock openssl' do
                     #  not_if 'grep "openssl-1.0.0-27.el6_4.2" /etc/yum/pluginconf.d/versionlock.list'
                     #end

                     execute 'yum versionlock openssl-devel' do
                       not_if 'grep "openssl-devel-1.0.0-27.el6_4.2" /etc/yum/pluginconf.d/versionlock.list'
                     end

                     %w(git readline readline-devel zlib-devel gcc curl-devel httpd-devel apr-devel apr-util-devel sqlite-devel libxml2-devel libxslt-devel libffi-devel)
                   else
                     raise node['platform_family']
                   end

general_packages.each do |pack|
  package pack do
    action :install
  end
end

node['rails-stack']['packages'].each do |pack|
  package pack do
    action :install
  end
end

# Nodejs
include_recipe 'nodejs'

# Imagemagick tools
include_recipe 'imagemagick::devel'

# Logrotate
include_recipe 'logrotate::default'

# Monit
include_recipe 'rails-stack::monit'
