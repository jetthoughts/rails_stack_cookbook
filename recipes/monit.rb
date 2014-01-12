node['rails-stack']['monitor_services'].each do |service_name|
  monitrc service_name do
    template_source "monit/#{service_name}.conf.erb"
    template_cookbook 'rails-stack'
  end
end
