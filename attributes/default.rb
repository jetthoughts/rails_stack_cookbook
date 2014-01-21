default['rails-stack']['data_path']        = '/data'
default['rails-stack']['apps_path']        = "#{node['rails-stack']['data_path']}/apps"
default['rails-stack']['deployer']         = 'deployer'
default['rails-stack']['applications']     = Array.new
default['rails-stack']['packages']         = Array.new
default['rails-stack']['packages']         = Array.new
default['rails-stack']['monitor_services'] = {nginx: true, memcached: true, postgresql: true}

default[:ruby][:version] = '2.1.0'

default[:rbenv][:install_prefix] = node['rails-stack']['data_path']
default[:rbenv][:root_path]      = "#{node[:rbenv][:install_prefix]}/rbenv"
default[:rbenv][:user]           = node['rails-stack']['deployer']
default[:rbenv][:group]          = node['rails-stack']['deployer']
default[:rbenv][:user_home]      = "/home/#{node['rails-stack']['deployer']}"

default['rails-stack'][:pg_distinct_clients] = false

# Postgresql values
default['postgresql']['version'] = '9.3'
default['postgresql']['config']['port'] = 5432
default['postgresql']['config']['ssl'] = false

# NOTICE: You should provide one of those values in the node settings to use latest Postgresql 9.2.
#default['postgresql']['enable_pgdg_yum'] = true
#default['postgresql']['enable_pgdg_apt'] = true

default['postgresql']['pg_hba'] = [
  { type: 'local', db: 'all', user: node['rails-stack']['deployer'], addr: nil,            method: 'peer'},
  { type: 'host',  db: 'all', user: node['rails-stack']['deployer'], addr: '127.0.0.1/32', method: 'trust'},
  { type: 'host',  db: 'all', user: node['rails-stack']['deployer'], addr: '::1/128',      method: 'trust'},
  { type: 'host',  db: 'all', user: 'all', addr: '127.0.0.1/32', method: 'md5'},
  { type: 'host',  db: 'all', user: 'all', addr: '::1/128', method: 'md5'}
]

# Sudoers
default[:authorization][:sudo][:include_sudoers_d] = true

default['nginx']['default_site_enabled'] = false
default['nodejs']['install_method'] = 'package'

# Memcached values
default['memcached']['listen'] = 'localhost'
# WARNING: This value is not from the origianl memchached value and required to for monit config only
case node['platform_family']
when 'rhel', 'fedora', 'centos'
  default['memcached']['pid'] = '/var/run/memcached/memcached.pid'
  default['postgresql']['pidfile'] = "/var/run/postgresql-#{node['postgresql']['version']}.pid"
when 'ubuntu', 'debian'
  default['memcached']['pid'] = '/var/run/memcached.pid'
  default['postgresql']['pidfile'] = node['postgresql']['config']['external_pid_file'] || "/var/run/postgresql/#{node['postgresql']['version']}-main.pid"
end
