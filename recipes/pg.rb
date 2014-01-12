
available_actions = ['restart', 'create user', 'create superuser', 'drop user', 'reset db']

# define actions
execute 'pg restart' do
  command 'service postgresql restart || service postgresql start'
  action :nothing
end

execute 'pg create user' do
  command "psql -c \"CREATE ROLE #{node[:postgresql][:pg_username]} UNENCRYPTED PASSWORD '#{node[:postgresql][:pg_password]}' NOSUPERUSER NOCREATEDB NOCREATEROLE INHERIT LOGIN;\""
  user 'postgres'
  action :nothing
  only_if { node[:postgresql][:pg_username] && node[:postgresql][:pg_password] }
  notifies :run, 'execute[pg create db]'
end

execute 'pg create superuser' do
  command "psql -c \"CREATE ROLE #{node[:postgresql][:pg_username]} UNENCRYPTED PASSWORD '#{node[:postgresql][:pg_password]}' SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN;\""
  user 'postgres'
  action :nothing
  only_if { node[:postgresql][:pg_username] && node[:postgresql][:pg_password] }
  notifies :run, 'execute[pg create db]'
end

# creates samenamed db for user
execute 'pg create db' do
  command "createdb #{node[:postgresql][:pg_username]} --owner=#{node[:postgresql][:pg_username]}"
  user 'postgres'
  action :nothing
  only_if { node[:postgresql][:pg_username] }
end

execute 'pg reset db' do
  command "dropdb #{node[:postgresql][:pg_username]}"
  user 'postgres'
  action :nothing
  only_if { node[:postgresql][:pg_username] }
  notifies :run, 'execute[pg create db]'
end

execute 'pg drop user' do
  command "dropdb #{node[:postgresql][:pg_username]}; dropuser #{node[:postgresql][:pg_username]}; true"
  user 'postgres'
  action :nothing
  only_if { node[:postgresql][:pg_username] }
end

# run specified action
execute 'pg action' do
  command "echo 'running pg action #{node[:postgresql][:pg_action]}'"
  only_if { available_actions.include? node[:postgresql][:pg_action] }
  notifies :run, "execute[pg #{node[:postgresql][:pg_action]}]"
end
