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

node['rails-stack']['monitor_services'].each do |service_name|
  monitrc service_name do
    template_source "monit/#{service_name}.conf.erb"
    template_cookbook 'rails-stack'
  end
end
