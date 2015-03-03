mysql_service 'default' do
  port node[:mysql][:port]
  version node[:mysql][:version]
  initial_root_password node[:mysql][:server_root_password]
  action [:create, :start]
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_connection_info = {host:     '127.0.0.1',
                         port:     node[:mysql][:port],
                         username: 'root',
                         password: node[:mysql][:server_root_password]}

mysql_database_user node['rails-stack']['deployer'] do
  connection mysql_connection_info
  if node[:mysql][:server_deployer_password].to_s.length > 0
    password node[:mysql][:server_deployer_password]
  end
  action [:create, :grant]
end
