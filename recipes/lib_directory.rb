data_path = node['rails-stack']['data_path']
dirs = [data_path, "#{data_path}/apps", "#{data_path}/tmp", "#{data_path}/tmp/nginx",
        "#{data_path}/tmp/nginx/cache", "#{data_path}/tmp/nginx/proxy"]

node['rails-stack']['applications'].each do |application_options|
  dirs << "#{data_path}/apps/#{application_options[:name]}"
  dirs << "#{data_path}/apps/#{application_options[:name]}/shared"
  dirs << "#{data_path}/apps/#{application_options[:name]}/shared/log"
  dirs << "#{data_path}/apps/#{application_options[:name]}/shared/tmp"
  dirs << "#{data_path}/apps/#{application_options[:name]}/shared/tmp/pids"
end

dirs.each do |dir|
  directory dir do
    action :create
    owner 'deployer'
    group 'deployer'
  end
end
