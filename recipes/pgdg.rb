include_recipe 'postgresql::contrib'

execute 'create deployer user for pg' do
  command "createuser #{node['rails-stack']['deployer']} -d -i"
  user 'postgres'
  ignore_failure true
  action :run
end
